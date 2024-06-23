//
//  FavoritesView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 20.06.2024.
//

import SwiftUI

struct FavoritesView: View {
    @State private var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.appBackground
                
                VStack(spacing: 8) {
                    Image.commingSoonIcon
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 150)
                    
                    Text("Comming soon")
                        .font(.title)
                }
                .foregroundStyle(.appTextSecondary)
                .opacity(0.3)

            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
