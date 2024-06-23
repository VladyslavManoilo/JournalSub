//
//  Image+App.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 20.05.2024.
//

import SwiftUI

extension Image {
    static var appCloseIcon: Image {
        return Image(systemName: "xmark")
    }
    
    static var appWarningIcon: Image {
        return Image(systemName: "exclamationmark.triangle")
    }

    static var appChevronLeft: Image {
        return Image(systemName: "chevron.left")
    }

    static var appLockIcon: Image {
        return Image(systemName: "lock.fill")
    }

    static var appSearchIcon: Image {
        return Image(systemName: "magnifyingglass")
    }

    static var commingSoonIcon: Image {
        return Image(systemName: "bubbles.and.sparkles.fill")
    }
}

// Tab Icons
extension Image {
    static var appTopNewsTabIcon: Image {
        return Image(systemName: "list.bullet.below.rectangle")
    }

    static var appBrowseTabIcon: Image {
        return Image(systemName: "globe")
    }

    static var appSavedTabIcon: Image {
        return Image(systemName: "heart.fill")
    }
}
