//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 10/27/22.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    
    private var deletionCompletions = [(Error?) -> Void]()
    private var insertionCompletions = [(Error?) -> Void]()
    private var retrievalCompletions = [(LocalFeedLoader.LoadResult) -> Void]()
    
    enum ReceivedMessage: Equatable {
        case deleteCacheItem
        case insertion([FeedItem], Date)
        case retrieve
    }
    
    var receivedMessage = [ReceivedMessage]()
    
    func deletionCacheItems(completion: @escaping (Error?) -> Void) {
        receivedMessage.append(.deleteCacheItem)
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping (Error?) -> Void) {
        receivedMessage.append(.insertion(items, timestamp))
        insertionCompletions.append(completion)
    }
    
    func retrieve(completion: @escaping (LocalFeedLoader.LoadResult) -> Void) {
        retrievalCompletions.append(completion)
        receivedMessage.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalSuccessfully(_ items: [FeedItem] = [],at index: Int = 0) {
        retrievalCompletions[index](.success(items))
    }
}
