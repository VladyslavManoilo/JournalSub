//
//  Data+Json.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import Foundation

extension Data {
    var jsonPrint: String {
        return "\((try? JSONSerialization.jsonObject(with: self)) ?? "No Json in data")"
    }
}
