//
//  SubscriptionModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 16.05.2024.
//

import Foundation

struct SubscriptionModel: Identifiable {
    let id: String
    let title: String
    let caption: String
    let price: String
    
    static var empty: SubscriptionModel {
        return SubscriptionModel(id: "-", title: "Unknown", caption: "No Caption", price: "0.00")
    }
}
