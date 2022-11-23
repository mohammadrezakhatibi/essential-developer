//
//  MainQueueDispatchDecorator.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/23/22.
//

import Foundation
import EssentialFeed

final class MainQueueDispatchDecorator<T> {
   private let decoratee: T
   
   init(decoratee: T) {
       self.decoratee = decoratee
   }
   
   func dispatch(completion: @escaping () -> Void) {
       guard Thread.isMainThread else {
           return DispatchQueue.main.async { completion() }
       }
       completion()
   }
}

// We decorate a new object that confirm FeedLoader with new behavior (move background queue to main queue)

extension MainQueueDispatchDecorator: FeedLoader where T == FeedLoader {
   func load(completion: @escaping (FeedLoader.Result) -> Void) {
       decoratee.load { [weak self] result in
           self?.dispatch { completion(result) }
       }
   }
}

extension MainQueueDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
   func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
       decoratee.loadImageData(from: url) { [weak self] result in
           self?.dispatch { completion(result) }
       }
   }
}
