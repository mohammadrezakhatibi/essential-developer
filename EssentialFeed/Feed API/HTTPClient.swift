//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/14/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
