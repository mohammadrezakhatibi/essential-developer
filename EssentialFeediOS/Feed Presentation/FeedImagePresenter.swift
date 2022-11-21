//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/20/22.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<Image> {
    var description: String?
    var location: String?
    let image: Image?
    let isLoading: Bool
    let isRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    associatedtype Image
    func display(with viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView,Image> where View.Image == Image {
    private var view: View
    private var imageTransformer: (Data) -> Image?
    
    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    func didStartLoadImageData(for model: FeedImage) {
        view.display(with: FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            isRetry: false))
    }
    
    private struct InvalidImageData: Error {}
    
    func didFinishLoadImageData(with data: Data, for model: FeedImage) {
        
        guard let image = imageTransformer(data) else {
            didFinishLoadImageData(with: InvalidImageData(), for: model)
            return
        }
        view.display(with: FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            isRetry: false))
    }
    
    func didFinishLoadImageData(with error: Error, for model: FeedImage) {
        view.display(with: FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: false,
            isRetry: true))
    }
}

