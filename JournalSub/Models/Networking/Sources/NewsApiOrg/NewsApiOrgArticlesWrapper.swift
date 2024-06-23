//
//  NewsApiOrgArticlesWrapper.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 22.05.2024.
//

import Foundation

struct NewsApiOrgArticlesWrapper: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsApiOrgArticle]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.articles = (try? container.decode([NewsApiOrgArticle].self, forKey: .articles)) ?? []
    }
}
