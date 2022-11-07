//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/18/22.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private var session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValueRepresentation: Error {}
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValueRepresentation()
                }
            })
        }.resume()
    }
}
