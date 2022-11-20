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

protocol FeedImageView: AnyObject {
    associatedtype Image
    func display(with viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView,Image> where View.Image == Image {
    
    weak var view: View?
    
    private var task: FeedImageDataLoaderTask?
    var model: FeedImage
    var imageLoader: FeedImageDataLoader
    var imageTransformer: (Data) -> Image?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    func loadImageData() {
        view?.display(with: FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            isRetry: false))
        task = imageLoader.loadImageData(from: self.model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            view?.display(with: FeedImageViewModel(
                description: model.description,
                location: model.location,
                image: image,
                isLoading: false,
                isRetry: false))
        } else {
            view?.display(with: FeedImageViewModel(
                description: model.description,
                location: model.location,
                image: nil,
                isLoading: false,
                isRetry: true))
        }
    }
    
    func cancelLoad() {
        task?.cancel()
        task = nil
    }
}

