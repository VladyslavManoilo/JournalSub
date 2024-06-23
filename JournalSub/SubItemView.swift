//
//  SubItemView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 15.05.2024.
//

import SwiftUI

struct SubItemView: View {
    let title: String
    let price: String
    let caption: String
    let buttonText: String
    
    let onButton: VoidClosure
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.appText)
                
                Text(price)
                    .font(.largeTitle)
                    .foregroundStyle(.appText)
                
                Text(caption)
                    .font(.headline)
                    .foregroundStyle(.appText)
                
                Button {
                    onButton()
                } label: {
                    Text(buttonText)
                }
                .buttonStyle(AppFilledButtonStyle())
                
            }
            .padding(LayoutConstants.internalPadding)
        }
        .background(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
            .inset(by: +LayoutConstants.strokeWidth)
            .stroke(LinearGradient(colors: Color.appColors, startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: LayoutConstants.strokeWidth)
        )
    }
}

#Preview {
    SubItemView(title: "The Sub Title", price: "99.9$", caption: "The Sub Caption...", buttonText: "Subscribe", onButton: {})
}
