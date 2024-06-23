//
//  NewsArticleModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation

struct NewsArticleModel: Identifiable, Hashable, Article {
    let id: String
    let title: String
    let details: String
    let imageURL: URL?
    let sourceURL: URL
}
