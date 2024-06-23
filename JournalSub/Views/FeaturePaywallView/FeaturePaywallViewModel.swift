//
//  FeaturePaywallViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 19.06.2024.
//

import Foundation
import Combine

final class FeaturePaywallViewModel: ObservableObject, Identifiable {
    let id: String
    
    private let purchaseManager: PurchaseManager
    private var bag: Set<AnyCancellable> = []
    private var purchaseTask: Task<Void, Error>?

    @Published var featureInfo: FeatureInfoModel
    @Published var errorText: String?
    @Published var isTransactionFinishedSuccessfully: Bool = false
    @Published var transactionInProgress: Bool = false
    
    init(purchaseManager: PurchaseManager, productId: String) {
        self.id = productId
        self.purchaseManager = purchaseManager
        self.featureInfo = FeatureInfoModel.empty
        
        purchaseManager.storage.$products
            .map { products in
                products.filter { $0.type == .nonConsumable }
            }
            .sink { products in
                if let correspondProduct = products.first(where: { $0.id == productId }) {
                    self.featureInfo = FeatureInfoModel(id: correspondProduct.id, title: correspondProduct.displayName, description: correspondProduct.description, price: correspondProduct.displayPrice)
                }
            }
            .store(in: &bag)
        
        purchaseManager.storage.$purchasedProducts.sink { [weak self] purchasedProducts in
            guard let self = self else {
                return
            }
            
            self.isTransactionFinishedSuccessfully = purchasedProducts.contains(where: { $0.id == productId })
            self.transactionInProgress = false
            self.errorText = nil
        }
        .store(in: &bag)
    }

    deinit {
        bag.forEach { $0.cancel() }
    }
    
    func featurePurchaseRequested() {
        purchaseTask?.cancel()
        
        purchaseTask = Task {
            await MainActor.run {
                transactionInProgress = true
            }
            
            do {
                try await purchaseManager.purchaseProduct(withId: featureInfo.id)
            } catch {
                await MainActor.run {
                    transactionInProgress = false
                    errorText = error.localizedDescription
                }
            }
        }
    }

    func featureRestoreRequested() {
        purchaseManager.restorePurchases()
    }
}
