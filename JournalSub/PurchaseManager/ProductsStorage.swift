//
//  ProductsStorage.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 16.05.2024.
//

import Foundation
import StoreKit

final class ProductsStorage {
    static let shared = ProductsStorage()
    
    @Published var products: [Product] = []
    @Published var purchasedProducts: [Product] = []
}
