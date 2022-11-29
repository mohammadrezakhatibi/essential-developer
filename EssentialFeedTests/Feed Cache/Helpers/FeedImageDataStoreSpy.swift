//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 11/29/22.
//

import Foundation
import EssentialFeed

internal class FeedImageDataStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case save(data: Data, for: URL)
    }
    var receivedMessages = [Message]()
    var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    var insertionCompletions = [(FeedImageDataStore.InsertionResult) -> Void]()
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        receivedMessages.append(.save(data: data, for: url))
        insertionCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertion(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
}
