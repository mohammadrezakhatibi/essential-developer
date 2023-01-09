//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/13/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    
    private var url: URL
    private var client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteFeedLoader.map(data, response: response))
                
            case .failure:
                completion(.failure(RemoteFeedLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, response: HTTPURLResponse) -> Result {
        
        do {
            let items = try FeedItemsMapper.map(data, response: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
        
    }
}
