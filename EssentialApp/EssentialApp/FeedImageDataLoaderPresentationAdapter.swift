//
//  FeedImageDataLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 12/16/22.
//

import EssentialFeed
import EssentialFeediOS
import Combine
import Foundation

public final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private var task: FeedImageDataLoaderTask?
    private var cancellable: Cancellable?
    
    public var presenter: FeedImagePresenter<View, Image>?

    public init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    public func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        cancellable = imageLoader(model.url)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self?.presenter?.didFinishLoadingImageData(with: error, for: model)
                }
            }, receiveValue: { [weak self] data in
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
            })
        
    }
    
    public func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
