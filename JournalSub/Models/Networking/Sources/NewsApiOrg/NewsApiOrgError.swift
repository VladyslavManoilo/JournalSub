//
//  NewsApiOrgError.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 22.05.2024.
//

import Foundation

struct NewsApiOrgError: Codable {
    let status: String
    let code: String
    let message: String
}

extension NewsApiOrgError: Error {
    var localizedDescription: String {
        return message
    }
}
