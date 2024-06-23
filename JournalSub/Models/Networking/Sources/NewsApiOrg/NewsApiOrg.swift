//
//  NewsApiOrg.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation
import Combine

struct NewsApiOrg: ApiSource {
    private let apiKey = "Place your api key here from https://newsapi.org/ (don't worry it should be free))"
    private let baseURL = "https://newsapi.org/v2/"
    private let countryCode = "us"
    
    private enum Route: String {
        case topHeadline = "top-headlines"
        case search = "everything"
    }
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    private let removedArticleIndicator = "[Removed]"
    
    func fetchArticles() -> AnyPublisher<[NewsArticleModel], ApiError> {
        guard var url = URL(string: baseURL + Route.topHeadline.rawValue) else {
            return Fail(error: .create(from: URLError(.badURL))).eraseToAnyPublisher()
        }
        
        url.append(queryItems: [URLQueryItem(name: "country", value: countryCode)])
        url.append(queryItems: [URLQueryItem(name: "apiKey", value: apiKey)])
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
                
        return newsDataTaskPublisher(for: urlRequest)
    }
    
    func searchForArticles(with text: String) -> AnyPublisher<[NewsArticleModel], ApiError> {
        guard var url = URL(string: baseURL + Route.topHeadline.rawValue) else {
            return Fail(error: .create(from: URLError(.badURL))).eraseToAnyPublisher()
        }
        
        url.append(queryItems: [URLQueryItem(name: "q", value: text)])
        url.append(queryItems: [URLQueryItem(name: "apiKey", value: apiKey)])
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
                
        return newsDataTaskPublisher(for: urlRequest)
    }
    
    private func newsDataTaskPublisher(for urlRequest: URLRequest) -> AnyPublisher<[NewsArticleModel], ApiError> {
        let decoder = JSONDecoder()

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap {
                guard let articlesWrapper = try? decoder.decode(NewsApiOrgArticlesWrapper.self, from: $0.data) else {
                    throw try decoder.decode(NewsApiOrgError.self, from: $0.data)
                }
                
                return articlesWrapper
            }
            .map {
                $0.articles.compactMap { remoteArticle in
                    var article: NewsArticleModel?
                    let isRemovedArticle = remoteArticle.url.absoluteString.contains(removedArticleIndicator) == true || remoteArticle.title == removedArticleIndicator
                    article = isRemovedArticle ? nil : remoteArticle.toNewsArticle()
                    return article
                }
            }
            .mapError {
                ApiError.create(from: $0)
            }
            .eraseToAnyPublisher()

    }
}

