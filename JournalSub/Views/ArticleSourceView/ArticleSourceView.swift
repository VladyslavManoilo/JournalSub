//
//  ArticleSourceView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 18.06.2024.
//

import SwiftUI
import WebKit

struct ArticleSourceView<T: Article>: View {
    @ObservedObject private var viewModel: ArticleSourceViewModel<T>
    let onBack: VoidClosure
    
    init(viewModel: ArticleSourceViewModel<T>, onBack: @escaping VoidClosure) {
        self.viewModel = viewModel
        self.onBack = onBack
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            WebView(url: viewModel.sourceURL)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onBack()
                } label: {
                    HStack(spacing: 2) {
                        Image.appChevronLeft
                        
                        Text("Back")
                    }
                    .contentShape(Rectangle())
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.sourceName)
    }
}

#Preview {
    ArticleSourceView<NewsArticleModel>(viewModel: ArticleSourceViewModel(article: NewsArticleModel(id: "0", title: "Some title", details: "Some details", imageURL: nil, sourceURL: URL(string: "https://www.linkedin.com/in/vladislav-manoilo-a16887296/")!)), onBack: {})
}
