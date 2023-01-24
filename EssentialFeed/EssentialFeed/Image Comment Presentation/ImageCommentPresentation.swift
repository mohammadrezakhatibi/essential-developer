//
//  ImageCommentPresentation.swift
//  EssentialFeed
//
//  Created by mohammadreza on 1/24/23.
//

import Foundation

public struct ImageCommentsViewModel {
    public let comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Equatable {
    let message: String
    let date: String
    let username: String
    
    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}

public final class ImageCommentPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: ImageCommentPresenter.self),
                                 comment: "Title for the image comment view")
    }
    
    public static func map(_ comments: [ImageComment],
                           currentDate: Date,
                           calendar: Calendar,
                           locale: Locale) -> ImageCommentsViewModel {
        
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        
        return ImageCommentsViewModel(comments: comments.map { comment in
            return ImageCommentViewModel(
                message: comment.message,
                date: formatter.localizedString(for: comment.createdAt, relativeTo: currentDate),
                username: comment.username)
        })
    }
}
