//
//  ImageCommentPresentation.swift
//  EssentialFeed
//
//  Created by mohammadreza on 1/24/23.
//

import Foundation

public final class ImageCommentPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: ImageCommentPresenter.self),
                                 comment: "Title for the image comment view")
    }
}
