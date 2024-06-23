//
//  ApiSourceType.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation

enum ApiSourceType {
    case newsApiOrg
    
    var source: ApiSource {
        switch self {
        case .newsApiOrg:
            return NewsApiOrg()
        }
    }
}
