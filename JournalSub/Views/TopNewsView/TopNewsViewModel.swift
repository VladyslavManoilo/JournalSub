//
//  TopNewsViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 16.05.2024.
//

import Foundation
import Combine

final class TopNewsViewModel: ObservableObject {
    private let purchaseManager: PurchaseManager
    private let apiManager: ApiManager
    private var contentFetchBag: Set<AnyCancellable> = []
    
    let articlesListViewModel: ArticlesListViewModel<NewsArticleModel>
    
    @Published var errorText: String?
    @Published var needsLoader: Bool = false
    
    var isFirstLoad: Bool = true
    
    init(purchaseManager: PurchaseManager, apiManager: ApiManager) {
        self.purchaseManager = purchaseManager
        self.apiManager = apiManager
        self.articlesListViewModel = ArticlesListViewModel(purchaseManager: purchaseManager, articles: [])
    }

    deinit {
        fetchContentCancelled()
    }
    
    private func fetchContentCancelled() {
        contentFetchBag.forEach { $0.cancel() }
    }
    
    func contentFetched() {
        if isFirstLoad {
            isFirstLoad = false
            needsLoader = true
        }
        
        fetchContentCancelled()
        
        let contentRequest = apiManager.fetchArticles()
        
        contentRequest
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
            switch completion {
            case .finished:
                debugPrint("ContentViewModel: fetchArticles finished")
            case .failure(let error):
                self?.errorText = error.localizedDescription
            }
            self?.needsLoader = false
        } receiveValue: { [weak self] articles in
            self?.articlesListViewModel.articles = articles
        }
        .store(in: &contentFetchBag)
    }
}
