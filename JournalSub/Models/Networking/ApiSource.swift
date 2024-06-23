//
//  ApiSource.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation
import Combine

protocol ApiSource {
    func fetchArticles() -> AnyPublisher<[NewsArticleModel], ApiError>
    func searchForArticles(with text: String) -> AnyPublisher<[NewsArticleModel], ApiError>
}
