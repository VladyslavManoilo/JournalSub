//
//  AppAsyncImage.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 18.06.2024.
//

import SwiftUI
import Combine

struct AppAsyncImage: View {
    @State var url: URL?
    @StateObject private var viewModel = AppAsyncImageViewModel()

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                    
                    Image(uiImage: image)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .layoutPriority(-1)
                }
            } else if viewModel.isDownloadFailed {
                Image.appWarningIcon
                    .renderingMode(.template)
                    .foregroundStyle(.appWarning)
                    .frame(maxWidth: .infinity)
            } else {
                ProgressHudView()
            }
        }
        .onChange(of: url, { oldValue, newValue in
            viewModel.fetchImage(url: newValue)
        })
        .task {
            viewModel.fetchImage(url: url)
        }
    }
}

#Preview {
    let urlString = "https://media.licdn.com/dms/image/D4D03AQHje63YwUvGSw/profile-displayphoto-shrink_800_800/0/1703753811278?e=1724284800&v=beta&t=So1Ic5BLy4e7aRA4xO8hWlYafZIqMAVrCmauoJSB_sQ"
    return AppAsyncImage(url: URL(string: urlString))
}
