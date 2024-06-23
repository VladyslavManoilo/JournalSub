//
//  NewsApiOrgArticle.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation

struct NewsApiOrgArticle: Codable {
    let title: String
    let description: String?
    let urlToImage: URL?
    let url: URL
    
    func toNewsArticle() -> NewsArticleModel {
        return NewsArticleModel(id: url.absoluteString, title: title, details: description ?? "", imageURL: urlToImage, sourceURL: url)
    }
}
