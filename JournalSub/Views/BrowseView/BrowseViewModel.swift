//
//  BrowseViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 20.06.2024.
//

import Foundation
import Combine

final class BrowseViewModel: ObservableObject {
    private let purchaseManager: PurchaseManager
    private let apiManager: ApiManager
    
    let articlesViewModel: ArticlesListViewModel<NewsArticleModel>
    
    private var searchRequestBag: Set<AnyCancellable> = []

    @Published var searchText: String = ""
    @Published var errorText: String = ""
    
    
    init(purchaseManager: PurchaseManager, apiManager: ApiManager) {
        self.purchaseManager = purchaseManager
        self.apiManager = apiManager
        self.articlesViewModel = ArticlesListViewModel(purchaseManager: purchaseManager, articles: [])
        
        $searchText
            .filter { !$0.isEmpty }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { searchText in
                apiManager.searchForArticles(with: searchText)
                    .mapError { error in
                        self.errorText = error.localizedDescription
                        return error
                    }
                    .replaceError(with: [])
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.articles, on: articlesViewModel)
            .store(in: &searchRequestBag)
    }
}
