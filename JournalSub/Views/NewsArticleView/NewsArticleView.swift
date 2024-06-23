//
//  NewsArticleView.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 21.05.2024.
//

import SwiftUI

struct NewsArticleView: View {
    private let imageHeight: CGFloat = 250
    
    let imageURL: URL?
    let title: String
    let detailsText: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                if let imageURL = imageURL {
                    AppAsyncImage(url: imageURL)
                        .frame(height: imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius))
                }
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.appText)
                    .lineLimit(2)
                
                Text(detailsText)
                    .font(.body)
                    .foregroundStyle(.appText)
                    .lineLimit(3)
            }
            .padding(LayoutConstants.internalPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius).fill(.appContainer))
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            NewsArticleView(imageURL: nil, title: "Test article title", detailsText: "Some test article description there")
            
            NewsArticleView(imageURL: URL(string: "https://ichef.bbci.co.uk/news/1024/branded_news/cc09/live/a8ee03f0-1753-11ef-b507-edbcd7518f5c.jpg"), title: "Test article title", detailsText: "Some test article description there...")
            
            NewsArticleView(imageURL: URL(string: "https://media.licdn.com/dms/image/D4D03AQHje63YwUvGSw/profile-displayphoto-shrink_800_800/0/1703753811278?e=1721865600&v=beta&t=GliWlVArsXh4tFnryclcK_j8qTzIuhB9E18b4qx4E80"), title: "Test article title", detailsText: "Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there Some test article description there")
        }
    }
}
