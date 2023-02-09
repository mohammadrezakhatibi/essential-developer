//
//  LocalFeedImageLoader.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 11/28/22.
//

import Foundation

public final class LocalFeedImageDataLoader {
    private let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader: FeedImageDataCache {
    
    public enum SaveError: Swift.Error {
        case failed
    }
    
    public typealias SaveResult = FeedImageDataCache.Result
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { [weak self] result in
            guard self != nil else { return }
            completion(result
                .mapError { _ in SaveError.failed }
                .flatMap { _ in .success(())} )
        }
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    
    private class LoadImageDataTask: FeedImageDataLoaderTask {
        
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    public typealias LoadResult = FeedImageDataLoader.Result
    
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError { _ in LoadError.failed }
                .flatMap { data in data.map { .success($0) } ?? .failure(LoadError.notFound) })
        }
        return task
    }
}
