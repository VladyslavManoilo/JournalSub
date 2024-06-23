//
//  ArticlesListView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 20.06.2024.
//

import SwiftUI

struct ArticlesListView<T: Article>: View {
    @ObservedObject private var viewModel: ArticlesListViewModel<T>
    
    init(viewModel: ArticlesListViewModel<T>) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                ZStack {
                    if viewModel.articles.isEmpty {
                        articlesListPlaceholder
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.articles) { article in
                                NewsArticleView(imageURL: article.imageURL, title: article.title, detailsText: article.details)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewModel.articleSelectedToRead(article)
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, LayoutConstants.horizontalPadding)
                .padding(.bottom, LayoutConstants.bottomPadding)
            }
            .navigationDestination(item: $viewModel.aricleSourceViewModel, destination: { aricleSourceViewModel in
                ArticleSourceView(viewModel: aricleSourceViewModel) {
                    viewModel.stopReadingArticle()
                }
            })
            .fullScreenCover(item: $viewModel.allSubsViewModel, content: { allSubsViewModel in
                AllSubsView(viewModel: allSubsViewModel,
                            onClose: {
                    viewModel.articleReadCanceled()
                })
            })
        }
    }
    
    private var articlesListPlaceholder: some View {
        VStack {
            
            Text("No news yet")
                .font(.title)
                .multilineTextAlignment(.center)
        }
        .opacity(0.3)
        .foregroundStyle(.appTextSecondary)
    }
}

#Preview {
    ArticlesListView(viewModel: ArticlesListViewModel<NewsArticleModel>(purchaseManager: PurchaseManager(), articles: []))
}
