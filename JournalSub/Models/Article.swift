//
//  Article.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.06.2024.
//

import Foundation

protocol Article: Identifiable, Hashable {
    var imageURL: URL? { get }
    var title: String { get }
    var details: String { get }
    var sourceURL: URL { get }
}
