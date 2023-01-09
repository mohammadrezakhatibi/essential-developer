//
//  RemoteImageCommentLoader.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 12/30/22.
//

import Foundation

public final class RemoteImageCommentLoader {
    
    private var url: URL
    private var client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<[ImageComment], Swift.Error>
    
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
            return .success(items)
        } catch {
            return .failure(error)
        }
        
    }
}
