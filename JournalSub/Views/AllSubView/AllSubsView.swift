//
//  AllSubsView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 15.05.2024.
//

import SwiftUI

struct AllSubsView: View {
    @StateObject private var viewModel: AllSubsViewModel
    
    @State private var transactionSuccessAnimationStarted: Bool = false
    
    let onClose: VoidClosure
    
    private let subItemButtonTitle = "Subscribe"
    
    init(viewModel: AllSubsViewModel, onClose: @escaping VoidClosure) {
        self.onClose = onClose
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        
                        Button {
                            onClose()
                        } label: {
                            ZStack {
                                Image.appCloseIcon
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .offset(x: 12)
                            }
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                        }
                    }
                    .padding(.horizontal, LayoutConstants.horizontalPadding)
                    .frame(height: 60)
                    .layoutPriority(999)
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                Text("Subscribe")
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                                    .foregroundStyle(.appText)
                                    .multilineTextAlignment(.center)
                                
                                Text("and be up to date with top worldwide news")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.appText)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, LayoutConstants.horizontalPadding)
                            
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.subscriptions) { product in
                                        SubItemView(title: product.title, price: product.price, caption: product.caption, buttonText: subItemButtonTitle, onButton: {
                                            viewModel.purchaseRequested(for: product)
                                        })
                                        .frame(width: (geometry.size.width - LayoutConstants.horizontalPadding * 2) / 1.5)
                                        
                                    }
                                }
                                .padding(.horizontal, LayoutConstants.horizontalPadding)
                            }
                            .scrollIndicators(.hidden)
                            .scrollBounceBehavior(.basedOnSize)
                            
                            Divider()
                            
                            VStack(spacing: 12) {
                                Text("Already subscribed?")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.appText)
                                    .multilineTextAlignment(.center)
                                
                                Text("restore your subscription by tapping on button below")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.appText)
                                    .multilineTextAlignment(.center)
                                
                                Button {
                                    viewModel.restorePuchases()
                                } label: {
                                    Text("Restore")
                                }
                                .buttonStyle(AppFilledButtonStyle())
                                
                                Text("Who even cares about privacy policy sections nowadays. Users just tapping on buttons, developers recieving money that how it works. If you are not agree just try to remember when did you read it last time...")
                                    .font(.body)
                                    .foregroundStyle(.appTextSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, LayoutConstants.horizontalPadding) 
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
                
                if viewModel.transactionInProgress {
                    ProgressHudView()
                }
                
                if let errorText = viewModel.errorText {
                    ErrorView(text: errorText) {
                        viewModel.errorText = nil
                    }
                }
            }
        }
    }
}

#Preview {
    AllSubsView(viewModel: AllSubsViewModel(purchaseManager: PurchaseManager()), onClose: {})
}
