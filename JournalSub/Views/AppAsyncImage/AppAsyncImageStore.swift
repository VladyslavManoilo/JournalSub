//
//  AppAsyncImageStore.swift
//  JournalSub
//
//  Created by DeveloperMB2020 on 18.06.2024.
//

import Foundation
import Combine

final class AppAsyncImageStore {
    static private let shared = AppAsyncImageStore()
    
    private let imageCache: URLCache = {
        let urlCache = URLCache(memoryCapacity: 100_000_000, diskCapacity: 500_000_000)
        return urlCache
    }()

    private lazy var cacheSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataDontLoad
        configuration.timeoutIntervalForRequest = 1
        configuration.urlCache = imageCache
        
        return URLSession(configuration: configuration)
    }()
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 10
        configuration.urlCache = imageCache
        
        return URLSession(configuration: configuration)
    }()
        
    private init() {
    }

    static func imageData(for url: URL) -> AnyPublisher<Data, Error> {
        shared.imageData(for: url)
    }
    
    private func imageData(for url: URL) -> AnyPublisher<Data, Error> {
        let cachePublisher = cacheSession.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }

        let remotePublisher = session.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }

        return cachePublisher
            .catch{ _ in
                remotePublisher
                    .eraseToAnyPublisher()

            }
            .flatMap { cachedData in
                remotePublisher
                    .filter { remoteData in
                        return remoteData != cachedData
                    }
                    .prepend(cachedData)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
