//
//  AppFilledButtonStyle.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 23.05.2024.
//

import SwiftUI

struct AppFilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
                .fill(.accent)
            )
            .contentShape(Rectangle())
    }
}
