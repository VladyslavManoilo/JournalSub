//
//  PurchaseManager.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 15.05.2024.
//

import Foundation
import StoreKit

fileprivate enum SubscriptionGroupId: String, CaseIterable {
    case allContentPlanGroupId = "AllContentPlan"
}

fileprivate enum SubscriptionId: String, CaseIterable {
    case yearlyAllContent = "yearlyAllContent"
    case monthlyAllContent = "monthlyAllContent"
    case weeklyAllContent = "weeklyAllContent"
    case specialDealSub = "specialDealSub"
}

enum PaidFeatures: String, CaseIterable {
    case browse = "BrowseNewsFeature"
}

final class PurchaseManager {
    typealias IApTransaction = StoreKit.Transaction
    typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

    let storage = ProductsStorage.shared
    
    private var productsIds: Set<String> = {
        let subscriptionIds = SubscriptionId.allCases.map { $0.rawValue }
        let featureIds = PaidFeatures.allCases.map { $0.rawValue }
        return Set<String>(subscriptionIds + featureIds)
    }()
    private var transactionListenerTask: Task<Void, Error>? = nil

    @Published var hasSubscribtionToAllContent: Bool = false

    var userHaveActionSubscription: Bool {
        return storage.purchasedProducts.contains(where: { $0.type == .autoRenewable })
    }
    
    enum TransactionError: Error {
        case verificationFailed
        case purchaseFailed
        case purchaseCancelled
    }

    deinit {
        transactionListenerTask?.cancel()
    }
    
    func start() async {
        transactionListenerTask = listenForTransactions()

        Task {
            await requestProducts()

            await updateCustomerProductStatus()
        }
    }
    
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.verifiedTransaction(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedProducts: [Product] = []

        for await result in IApTransaction.currentEntitlements {
            do {
                let transaction = try verifiedTransaction(result)

                switch transaction.productType {
                case .nonConsumable, .autoRenewable:
                    if let purchasedProduct = storage.products.first(where: { $0.id == transaction.productID }) {
                        purchasedProducts.append(purchasedProduct)
                    }
                    
                    break
                case .nonRenewable:
                    if transaction.productID == "SpecialDealSub",
                       let specialDeal = storage.products.first(where: { $0.id == transaction.productID }) {
                        let currentDate = Date()
                        let expirationDate = Calendar(identifier: .gregorian)
                            .date(byAdding: DateComponents(month: 1), to: transaction.purchaseDate)!
                        
                        if currentDate < expirationDate {
                            purchasedProducts.append(specialDeal)
                        }
                    }
                default:
                    break
                }
            } catch {
                debugPrint("PurchaseManager update product status failed with: \(error.localizedDescription)")
            }
        }

        hasSubscribtionToAllContent = purchasedProducts.contains(where: { $0.subscription?.subscriptionGroupID == SubscriptionGroupId.allContentPlanGroupId.rawValue })
        storage.purchasedProducts = purchasedProducts
    }
    
    func restorePurchases() {
        Task {
            try? await AppStore.sync()
        }
    }
    
    private func verifiedTransaction<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw TransactionError.verificationFailed
        case .verified(let verifiedValue):
            return verifiedValue
        }
    }
    
    private func requestProducts() async {
        let products = try? await Product.products(for: productsIds)
        storage.products = products ?? []
    }

    func purchaseProduct(withId id: String) async throws {
        guard let product = storage.products.first(where: { $0.id == id }) else {
            throw TransactionError.purchaseFailed
        }
        
        let purchaseResult = try await product.purchase()
        
        switch purchaseResult {
        case .success(let verificationResult):
            if let error = await handle(verificationResult: verificationResult) {
                debugPrint(error.localizedDescription)
                throw TransactionError.purchaseFailed
            }
            
            
        case .pending:
            break
        case .userCancelled:
            throw TransactionError.purchaseCancelled
        @unknown default:
            break
        }
    }
    
    private func handle(verificationResult: VerificationResult<IApTransaction>) async -> Error? {
        switch verificationResult {
        case .verified(let transaction):
            await updateCustomerProductStatus()
            await transaction.finish()
            return nil
        case .unverified(let transaction, let error):
            debugPrint("Transaction \(transaction.id) failed with: \(error.localizedDescription)")
            return error
        }
    }
}
