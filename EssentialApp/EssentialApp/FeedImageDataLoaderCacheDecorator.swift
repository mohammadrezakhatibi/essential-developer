//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by mohammadreza on 12/2/22.
//

import Foundation
import EssentialFeed

public final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.saveIgnoringResult(data, for: url)
                return data
            })
        }
    }
}

private extension FeedImageDataLoaderCacheDecorator {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        cache.save(data, for: url, completion: { _ in })
    }
}