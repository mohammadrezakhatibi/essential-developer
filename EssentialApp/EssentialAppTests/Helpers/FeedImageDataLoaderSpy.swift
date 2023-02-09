//
//  FeedImageDataLoaderSpy.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/2/22.
//

import Foundation
import EssentialFeed

final class FeedImageDataLoaderSpy: FeedImageDataLoader {
    
    var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
    var loaderURLs: [URL] {
        return messages.map { $0.url }
    }
    var canceledURLs = [URL]()
    
    private struct Task: FeedImageDataLoaderTask {
        var callback: () -> Void
        
        func cancel() {
            callback()
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.canceledURLs.append(url)
        }
    }
    
    func complete(with data: Data, at index: Int = 0) {
        messages[index].completion(.success(data))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
}
