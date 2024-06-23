//
//  MainView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 19.06.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                switch viewModel.selectedTabItem {
                case .topNews:
                    TopNewsView(viewModel: viewModel.topNewsViewModel)
                case .browse:
                    BrowseView(viewModel: viewModel.browseViewModel)
                case .saved:
                    FavoritesView()
                }
            }
            .fullScreenCover(item: $viewModel.featurePaywallViewModel, content: { featurePaywallViewModel in
                FeaturePaywallView(viewModel: featurePaywallViewModel, onClose: {
                    viewModel.featurePurchaseCancelled()
                })
            })
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        ForEach(viewModel.tabItems) { tabItem in
                            let isSelected = tabItem.id == viewModel.selectedTabItem.id
                            
                            ZStack {
                                ZStack(alignment: .topTrailing) {
                                    tabItemView(withTitle: tabItem.title, icon: tabItem.icon, isSelected: isSelected)
                                        .contentShape(Rectangle())
                                    
                                        .onTapGesture {
                                            viewModel.tabItemSelected(tabItem)
                                        }
                                    
                                    if !viewModel.isTabItemAvailable(tabItem) {
                                        Image.appLockIcon
                                            .renderingMode(.template)
                                            .resizable()
                                            .foregroundStyle(.appRed)
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
    
    private func tabItemView(withTitle title: String, icon: Image, isSelected: Bool) -> some View {
        return VStack(spacing: 2) {
            icon
                .renderingMode(.template)
            
            Text(title)
                .font(.footnote)
        }
        .foregroundStyle(isSelected ? .appText : .appText.opacity(0.2))
    }
}

#Preview {
    MainView(viewModel: MainViewModel(purchaseManager: PurchaseManager()))
}
