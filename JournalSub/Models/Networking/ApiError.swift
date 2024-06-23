//
//  ApiError.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation

enum ApiError: Error {
    case sourceNotAvailable
    case unknown(localizedDescription: String)

    static func create(from error: Error) -> ApiError {
        return .unknown(localizedDescription: error.localizedDescription)
    }
    
    var localizedDescription: String {
        switch self {
        case .sourceNotAvailable:
            return "News source is not available! Please try later again"
        case .unknown(let localizedDescription):
            return localizedDescription
        }
    }
}
