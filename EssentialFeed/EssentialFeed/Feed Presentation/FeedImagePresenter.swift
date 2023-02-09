//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 11/27/22.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
