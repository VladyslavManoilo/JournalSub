//
//  ErrorView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 22.05.2024.
//

import SwiftUI

struct ErrorView: View {
    let text: String
    let onOK: VoidClosure
    
    var body: some View {
        ZStack {
            Color.appHud
                .ignoresSafeArea()
            
            ZStack {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Error")
                            .font(.title)
                            .foregroundStyle(.appText)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        
                        Text(text)
                            .font(.body)
                            .foregroundStyle(.appText)
                    }
                    
                    Button {
                        onOK()
                    } label: {
                        Text("OK")
                    }
                    .buttonStyle(AppFilledButtonStyle())
                }
            }
            .padding(LayoutConstants.internalPadding)
            .background(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius).fill(.appContainer))
            .padding(LayoutConstants.horizontalPadding)
        }
    }
}

#Preview {
    ErrorView(text: "Some error message!", onOK: {})
}
