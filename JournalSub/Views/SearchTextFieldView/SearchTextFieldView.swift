//
//  SearchTextFieldView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 20.06.2024.
//

import SwiftUI

struct SearchTextFieldView: View {
    @Binding var searchText: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 4) {
                TextField("", text: $searchText, prompt: Text("Search"))
                    .keyboardType(.webSearch)
                    .foregroundStyle(.appText)
                    .frame(height: 44)
                    .focused($isFocused)
                
                if !isFocused {
                    Image.appSearchIcon
                }
            }
            .padding(.horizontal, 8)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .background(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius).fill(.appContainer))
        .padding(LayoutConstants.horizontalPadding)
    }
}

#Preview {
    SearchTextFieldView(searchText: .constant(""))
}
