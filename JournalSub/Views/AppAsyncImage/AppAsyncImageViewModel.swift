//
//  AppAsyncImageViewModel.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 18.06.2024.
//

import Foundation
import Combine
import UIKit

final class AppAsyncImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isDownloadFailed: Bool = false
    
    
    private var bag: Set<AnyCancellable> = []
    
    deinit {
        bag.forEach { $0.cancel() }
    }
    
    func fetchImage(url: URL?) {
        guard let url = url else {
            return
        }
        
        bag.forEach { $0.cancel() }

        AppAsyncImageStore.imageData(for: url)
            .sink { [weak self] completion in
            guard let self = self else {
                return
            }

            switch completion {
            case .finished:
                debugPrint("AppAsyncImageViewModel: finished download")
            case .failure(let error):
                debugPrint("AppAsyncImageViewModel: image failed to download with \(error.localizedDescription)")
                Task {
                    await MainActor.run {
                        self.isDownloadFailed = self.image == nil
                    }
                }
            }
        } receiveValue: { [weak self] imageData in
            guard let self = self else {
                return
            }
            let image = UIImage(data: imageData)
            Task {
                await MainActor.run {
                    print("set image:", url)
                    self.image = image
                }
            }
        }
        .store(in: &bag)

    }
}
