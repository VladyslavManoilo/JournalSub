//
//  FeatureInfoModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 19.06.2024.
//

import Foundation

struct FeatureInfoModel {
    let id: String
    let title: String
    let description: String
    let price: String
    
    static var empty: FeatureInfoModel {
        return FeatureInfoModel(id: "-", title: "Unknown", description: "No caption", price: "0.00")
    }
}
