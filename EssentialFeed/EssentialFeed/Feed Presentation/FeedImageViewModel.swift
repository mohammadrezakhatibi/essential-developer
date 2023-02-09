//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 11/27/22.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
