//
//  RemoteImageCommentLoader.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 12/30/22.
//

import Foundation

public typealias RemoteImageCommentLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentMapper.map)
    }
}
