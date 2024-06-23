//
//  AllSubsViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 15.05.2024.
//

import Foundation
import Combine

final class AllSubsViewModel: ObservableObject, Identifiable {
    let id: String = UUID().uuidString
    
    private let purchaseManager: PurchaseManager
    private var purchaseTask: Task<Void, Error>?
    private var subscriptionObserverBag = Set<AnyCancellable>()
    
    @Published var transactionInProgress: Bool = false
    @Published var subscriptions: [SubscriptionModel] = []
    @Published var errorText: String?
    @Published var isTransactionFinishedSuccessfully: Bool = false
        
    init(purchaseManager: PurchaseManager) {
        self.purchaseManager = purchaseManager
        
        purchaseManager.storage.$products
            .map { products in
                products.sorted { $0.price > $1.price }.compactMap { product in
                    var subscription: SubscriptionModel?
                    if product.type == .autoRenewable {
                        subscription = SubscriptionModel(id: product.id, title: product.displayName, caption: product.description, price: product.displayPrice)
                    }
                    
                    return subscription
                }
            }
            .sink(receiveValue: { [weak self] subscriptions in
                self?.subscriptions = subscriptions
            })
            .store(in: &subscriptionObserverBag)
    }
    
    deinit {
        subscriptionObserverBag.forEach { $0.cancel() }
    }
    
    func purchaseRequested(for product: SubscriptionModel) {
        subscriptionObserverBag.forEach { $0.cancel() }
        purchaseTask?.cancel()
        
        self.purchaseManager.storage.$purchasedProducts.sink { [weak self] purchasedProducts in
            self?.isTransactionFinishedSuccessfully = purchasedProducts.contains(where: { $0.id == product.id })
            self?.transactionInProgress = false
            self?.errorText = nil
        }.store(in: &subscriptionObserverBag)
        
        purchaseTask = Task {
            await MainActor.run {
                transactionInProgress = true
            }
            
            do {
                try await purchaseManager.purchaseProduct(withId: product.id)
            } catch {
                await MainActor.run {
                    transactionInProgress = false
                    errorText = error.localizedDescription
                }
            }
        }
    }
    
    func restorePuchases() {
        purchaseManager.restorePurchases()
    }
}
