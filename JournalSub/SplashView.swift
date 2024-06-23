//
//  SplashView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 17.05.2024.
//

import SwiftUI

struct SplashView: View {
    private let animationDuration: CGFloat = 0.3
    private let animationDelay: CGFloat = 1
    private let colors: [Color] = Color.appColors
    @State private var yOffsetForColors: [Color: CGFloat] = [:]
    let hideAnimation: Bool
    var onEndAnimating: VoidClosure?
    
    @State private var isStartHiddingAnimation: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                ZStack {
                    let size = geometry.size.width / CGFloat(colors.count)
                    ForEach(0...Int(round(geometry.size.height / size)), id: \.self) { _ in
                        
                        HStack(spacing: 0) {
                            ForEach(colors, id: \.self) { color in
                                color
                                    .frame(width: size)
                                    .frame(height: geometry.size.height)
                                    .offset(y: (isStartHiddingAnimation ? yOffsetForColors[color] : 0) ?? 0)
                                    .id(color)
                            }
                        }
                    }
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        ZStack {
                            appNameView
                                .shadow(radius: 10)
                            
                            appNameView
                                .foregroundStyle(.white)
                                .shadow(color: .black, radius: 1)
                        }
                        .padding(.bottom, 160)
                        
                        Spacer()
                    }
                    .opacity(isStartHiddingAnimation ? 0 : 1)
                    .layoutPriority(999)
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(2)
                }
                .onAppear {
                    var directionBottom = false
                    colors.forEach { color in
                        yOffsetForColors[color] = directionBottom ? geometry.size.height : -geometry.size.height
                        directionBottom.toggle()
                    }
                    
                    guard hideAnimation else {
                        return
                    }
                    withAnimation(.linear(duration: animationDuration).delay(animationDelay)) {
                        isStartHiddingAnimation = true
                    }
                    
                    let delayInSeconds: TimeInterval = TimeInterval(animationDuration + animationDelay)
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                        onEndAnimating?()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private var appNameView: some View {
        Text(StringConstants.appName)
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }
    
    private func lineHeight(fromHeight height: CGFloat) -> CGFloat {
        return height * 0.2
    }
}

#Preview {
    SplashView(hideAnimation: false)
}
