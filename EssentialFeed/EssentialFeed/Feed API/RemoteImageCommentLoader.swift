//
//  RemoteImageCommentLoader.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 12/30/22.
//

import Foundation

public final class RemoteImageCommentLoader: FeedLoader {
    
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
                completion(RemoteImageCommentLoader.map(data, response: response))
                
            case .failure:
                completion(.failure(RemoteImageCommentLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, response: HTTPURLResponse) -> Result {
        
        do {
            let items = try ImageCommentMapper.map(data, response: response)
            return .success(items.toModel())
        } catch {
            return .failure(error)
        }
        
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModel() -> [FeedImage] {
        return map {
            FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image)
        }
    }
}
