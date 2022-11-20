//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/17/22.
//
//
//import Foundation
//import EssentialFeed
//
//final class FeedImageViewModel<Image> {
//    typealias Observer<T> = (T) -> Void
//    
//    private var task: FeedImageDataLoaderTask?
//    var model: FeedImage
//    var imageLoader: FeedImageDataLoader
//    var imageTransformer: (Data) -> Image?
//    
//    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
//        self.model = model
//        self.imageLoader = imageLoader
//        self.imageTransformer = imageTransformer
//    }
//    
//    var description: String? {
//        return model.description
//    }
//    
//    var location: String? {
//        return model.location
//    }
//    
//    var hasLocation: Bool {
//        return location != nil
//    }
//    
//    var onImageLoad: Observer<Image>?
//    var onImageLoadingStateChange: Observer<Bool>?
//    var onShouldRetryImageLoadStateChange: Observer<Bool>?
//    
//    func loadImageData() {
//        onImageLoadingStateChange?(true)
//        onShouldRetryImageLoadStateChange?(false)
//        task = imageLoader.loadImageData(from: self.model.url) { [weak self] result in
//            self?.handle(result)
//        }
//    }
//    
//    private func handle(_ result: FeedImageDataLoader.Result) {
//        if let image = (try? result.get()).flatMap(imageTransformer) {
//            onImageLoad?(image)
//        } else {
//            onShouldRetryImageLoadStateChange?(true)
//        }
//        onImageLoadingStateChange?(false)
//    }
//    
//    func cancelLoad() {
//        task?.cancel()
//        task = nil
//    }
//}
