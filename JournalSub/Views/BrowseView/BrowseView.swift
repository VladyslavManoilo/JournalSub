//
//  BrowseView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 20.06.2024.
//

import SwiftUI

struct BrowseView: View {
    @StateObject private var viewModel: BrowseViewModel
    
    init(viewModel: BrowseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                SearchTextFieldView(searchText: $viewModel.searchText)
                
                ArticlesListView(viewModel: viewModel.articlesViewModel)
            }
        }
        .navigationTitle("Browse")
    }
    
}

#Preview {
    BrowseView(viewModel: BrowseViewModel(purchaseManager: PurchaseManager(), apiManager: ApiManager(sourceType: .newsApiOrg)))
}
