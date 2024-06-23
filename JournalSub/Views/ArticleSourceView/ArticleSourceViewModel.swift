//
//  ArticleSourceViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 18.06.2024.
//

import Foundation

final class ArticleSourceViewModel<T: Article>: ObservableObject {
    private let article: T

    let sourceName: String
    var sourceURL: URL {
        return article.sourceURL
    }
    
    init(article: T) {
        self.article = article
        self.sourceName = article.sourceURL.host() ?? ""
    }
}

extension ArticleSourceViewModel: Hashable {
    static func == (lhs: ArticleSourceViewModel, rhs: ArticleSourceViewModel) -> Bool {
        return lhs.article.id == rhs.article.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(article.id)
        hasher.combine(article)
    }
}
