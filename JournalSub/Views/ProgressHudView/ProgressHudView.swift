//
//  ProgressHudView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 23.05.2024.
//

import SwiftUI

struct ProgressHudView: View {
    private let colorHeight: CGFloat = 30
    private let colorWidth: CGFloat = 3
    private let animationDuration: Double = 0.3
    private var delayRate: Double {
        return animationDuration / 2
    }
    
    private var colors = Color.appColors
    
    @State private var isStart: Bool = false
        
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.5)
                .ignoresSafeArea()
            
            HStack(spacing: 6) {
                ForEach(colors.indices, id: \.self) { colorIndex in
                    colors[colorIndex]
                        .scaleEffect(x: isStart ? 1.1 : 1, y: isStart ? 1.8 : 1)
                        .frame(width: colorWidth, height: colorHeight)
                        .animation(
                            .linear(duration: animationDuration)
                            .delay(delayRate * Double(colorIndex)),
                            value: isStart)
                }
            }
        }
        .onAppear {
            isStart = true
            
           repeatAnimation()
        }
    }
    
    private func repeatAnimation() {
        let convertedColorsCount: Double = Double(colors.count)
        let animationEndTime: TimeInterval = animationDuration * delayRate + delayRate * convertedColorsCount
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationEndTime) {
            isStart.toggle()
            repeatAnimation()
        }
    }
}

#Preview {
    ProgressHudView()
}
