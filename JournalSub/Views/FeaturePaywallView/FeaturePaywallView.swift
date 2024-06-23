//
//  FeaturePaywallView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 19.06.2024.
//

import SwiftUI

struct FeaturePaywallView: View {
    @StateObject private var viewModel: FeaturePaywallViewModel
    private let onClose: VoidClosure
    
    init(viewModel: FeaturePaywallViewModel, onClose: @escaping VoidClosure) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onClose = onClose
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
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
                
                
                VStack(spacing: 16) {
                    Text("Unlock Feature")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(.appText)
                        .multilineTextAlignment(.center)
                    VStack(spacing: 8) {
                        Text(viewModel.featureInfo.title)
                            .font(.title)
                            .foregroundStyle(.appText)
                        
                        Text(viewModel.featureInfo.price)
                            .font(.title2)
                            .foregroundStyle(.appText)
                        
                        Button {
                            viewModel.featurePurchaseRequested()
                        } label: {
                            Text("Buy")
                        }
                        .buttonStyle(AppFilledButtonStyle())
                        
                        Text(viewModel.featureInfo.description)
                            .font(.body)
                            .foregroundStyle(.appTextSecondary)
                    }
                    .padding(LayoutConstants.internalPadding)
                    .background(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
                        .inset(by: +LayoutConstants.strokeWidth)
                        .stroke(LinearGradient(colors: Color.appColors, startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: LayoutConstants.strokeWidth)
                    )
                }
                .padding(LayoutConstants.horizontalPadding)

                
                Divider()
                
                VStack(spacing: 8) {
                    Text("Have it already?")
                        .font(.title)
                        .foregroundStyle(.appText)
                    
                    Button {
                        viewModel.featureRestoreRequested()
                    } label: {
                        Text("Resotre")
                    }
                    .buttonStyle(AppFilledButtonStyle())
                }
                .padding(LayoutConstants.horizontalPadding)
                
                Spacer()
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

#Preview {
    FeaturePaywallView(viewModel: FeaturePaywallViewModel(purchaseManager: PurchaseManager(), productId: PaidFeatures.browse.rawValue), onClose: {})
}
