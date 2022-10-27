//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/27/22.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deletionCacheItems { [weak self] error in
            guard let self = self else { return }
            if let error {
                completion(error)
                
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public typealias LoadResult = Result
    
    public enum Result {
        case success([FeedItem])
        case failure(Error?)
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        store.retrieve { result in
            switch result {
            case let .success(items):
                completion(.success(items))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    func deletionCacheItems(completion: @escaping DeletionCompletion)
    
    typealias InsertionCompletion = (Error?) -> Void
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
    
    func retrieve(completion: @escaping (LocalFeedLoader.LoadResult) -> Void)
}
