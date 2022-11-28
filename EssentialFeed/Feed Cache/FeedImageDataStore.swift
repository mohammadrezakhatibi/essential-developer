//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 11/28/22.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
