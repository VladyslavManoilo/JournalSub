//
//  JournalSubApp.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 15.05.2024.
//

import SwiftUI

@main
struct JournalSubApp: App {
    private let purchaseManager = PurchaseManager()
    
    @State var isAppReady: Bool = false
    @State var showSplash: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !isAppReady {
                    SplashView(hideAnimation: false)
                        .onAppear {
                            Task {
                                await purchaseManager.start()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    isAppReady = true
                                }
                            }
                        }
                } else {
                    ZStack {
                        if showSplash {
                            SplashView(hideAnimation: true, onEndAnimating: {
                                showSplash = false
                            })
                        } else {
                            MainView(viewModel: MainViewModel(purchaseManager: purchaseManager))
                        }
                    }
                }
            }
        }
    }
}
