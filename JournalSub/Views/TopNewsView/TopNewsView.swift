//
//  TopNewsView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 15.05.2024.
//

import SwiftUI

struct TopNewsView: View {
    @StateObject private var viewModel: TopNewsViewModel
    
    init(viewModel: TopNewsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                if viewModel.needsLoader {
                    ProgressHudView()
                } else {
                    ArticlesListView(viewModel: viewModel.articlesListViewModel)
                        .refreshable {
                            viewModel.contentFetched()
                        }
                }
                
                ZStack {
                    if let errorText = viewModel.errorText {
                        ErrorView(text: errorText, onOK: {
                            viewModel.errorText = nil
                        })
                    }
                }
                .ignoresSafeArea()
            }
            .task {
                viewModel.contentFetched()
            }
        }
        .navigationTitle("Top News")
    }
}

#Preview {
    TopNewsView(viewModel: TopNewsViewModel(purchaseManager: PurchaseManager(), apiManager: ApiManager(sourceType: .newsApiOrg)))
}
