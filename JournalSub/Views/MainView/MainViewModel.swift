//
//  MainViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 19.06.2024.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    private let purchaseManager: PurchaseManager
    
    let tabItems: [TabItem] = TabItem.allCases

    @Published var purchasedProductsIds: [String] = []
    @Published var selectedTabItem: TabItem = .topNews
    @Published var featurePaywallViewModel: FeaturePaywallViewModel?
    
    private var bag: Set<AnyCancellable> = []
    private var featuresBag: Set<AnyCancellable> = []
    private var apiManager: ApiManager {
        return ApiManager(sourceType: .newsApiOrg)
    }
    
    var topNewsViewModel: TopNewsViewModel {
        return TopNewsViewModel(purchaseManager: purchaseManager, apiManager: apiManager)
    }
    
    var browseViewModel: BrowseViewModel {
        return BrowseViewModel(purchaseManager: purchaseManager, apiManager: apiManager)
    }
    
    init(purchaseManager: PurchaseManager) {
        self.purchaseManager = purchaseManager
        
        self.purchaseManager.storage.$purchasedProducts.sink { [weak self] purchasedProducts in
            guard let self = self else {
                return
            }

            self.purchasedProductsIds = purchasedProducts.map { $0.id }
        }
        .store(in: &bag)
    }
    
    deinit {
        bag.forEach { $0.cancel() }
        featuresBag.forEach { $0.cancel() }
    }
    
    func tabItemSelected(_ tabItem: TabItem) {
        if let productId = tabItem.productId, !purchasedProductsIds.contains(productId) {
            featurePaywallViewModel = FeaturePaywallViewModel(purchaseManager: purchaseManager, productId: productId)
            featurePaywallViewModel?.$isTransactionFinishedSuccessfully
                .first(where: { $0 })
                .sink { [weak self] isFinished in
                guard let self = self else {
                    return
                }
                
                if isFinished {
                    self.tabItemUnlocked(tabItem)
                }
            }
            .store(in: &featuresBag)
        } else {
            selectedTabItem = tabItem
        }
    }
    
    private func tabItemUnlocked(_ tabItem: TabItem) {
        featuresBag.forEach { $0.cancel() }
        featurePaywallViewModel = nil
        tabItemSelected(tabItem)
    }

    func isTabItemAvailable(_ tabItem: TabItem) -> Bool {
        if let productId = tabItem.productId {
            return purchasedProductsIds.contains(productId)
        } else {
            return true
        }
    }
    
    func featurePurchaseCancelled() {
        featurePaywallViewModel = nil
    }
}
