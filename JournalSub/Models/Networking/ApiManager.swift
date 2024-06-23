//
//  ApiManager.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation
import Combine

struct ApiManager {
    let sourceType: ApiSourceType
    
    func fetchArticles() -> AnyPublisher<[NewsArticleModel], ApiError> {
        return sourceType.source.fetchArticles()
    }
    
    func searchForArticles(with text: String) -> AnyPublisher<[NewsArticleModel], ApiError> {
        return sourceType.source.searchForArticles(with: text)
    }
}
