//
//  ArticlesListViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.06.2024.
//

import Foundation
import Combine

final class ArticlesListViewModel<T: Article>: ObservableObject {
    private let purchaseManager: PurchaseManager
    private var articleSelectedToRead: T?
    private var allSubsViewModelBag: Set<AnyCancellable> = []
    
    @Published var aricleSourceViewModel: ArticleSourceViewModel<T>?
    @Published var allSubsViewModel: AllSubsViewModel?
    @Published var articles: [T]

    init(purchaseManager: PurchaseManager, articles: [T]) {
        self.purchaseManager = purchaseManager
        self.articles = articles
    }
    
    deinit {
        allSubsViewModelBag.forEach { $0.cancel() }
    }
    
    func articleSelectedToRead(_ article: T) {
        articleSelectedToRead = article
        
        if purchaseManager.userHaveActionSubscription {
            aricleSourceViewModel = ArticleSourceViewModel(article: article)
        } else {
            allSubsViewModel = AllSubsViewModel(purchaseManager: purchaseManager)
            allSubsViewModel?.$isTransactionFinishedSuccessfully
                .first(where: { $0 })
                .sink { [weak self] isFinished in
                guard let self = self else {
                    return
                }
                
                if isFinished {
                    self.readSelectedArticle()
                }
            }
            .store(in: &allSubsViewModelBag)
        }
    }
    
    func articleReadCanceled() {
        articleSelectedToRead = nil
        removeAllSubViewModel()
    }
    
    private func removeAllSubViewModel() {
        allSubsViewModelBag.forEach { $0.cancel() }
        allSubsViewModel = nil
    }
    
    func readSelectedArticle() {
        removeAllSubViewModel()
        guard let articleSelectedToRead = articleSelectedToRead else {
            return
        }
        
        self.articleSelectedToRead = nil
        aricleSourceViewModel = ArticleSourceViewModel(article: articleSelectedToRead)
    }
    
    func stopReadingArticle() {
        aricleSourceViewModel = nil
    }
}
