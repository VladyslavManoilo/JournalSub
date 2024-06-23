//
//  TabItem.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 19.06.2024.
//

import Foundation
import SwiftUI

enum TabItem: String, CaseIterable {
    case topNews
    case browse
    case saved
}

extension TabItem {
    var title: String {
        switch self {
        case .topNews:
            return "Top"
        case .browse:
            return "Browse"
        case .saved:
            return "Saved"
        }
    }
    
    var icon: Image {
        switch self {
        case .topNews:
            return .appTopNewsTabIcon
        case .browse:
            return .appBrowseTabIcon
        case .saved:
            return .appSavedTabIcon
        }
    }
}

extension TabItem {
    var productId: String? {
        switch self {
        case .topNews:
            return nil
        case .browse:
            return PaidFeatures.browse.rawValue
        case .saved:
            return nil
        }
    }
}

extension TabItem: Identifiable {
    var id: String {
        rawValue
    }
}
