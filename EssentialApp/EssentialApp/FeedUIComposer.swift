import EssentialFeed
import UIKit
import EssentialFeediOS
import Combine

public final class FeedUIComposer {
    private init() {}
    
    public typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    public static func feedComposeWith(
        feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
        imageLoader:  @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: { feedLoader().dispatchOnMainQueue() })
        
        let feedController = ListViewController()
        feedController.onRefresh = presentationAdapter.loadResource 
        feedController.title = FeedPresenter.title
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(forwardingTo: feedController, imageLoader: { imageLoader($0).dispatchOnMainQueue() }, selection: selection),
            loadingView:  WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: { $0 })
        
        return feedController
    }
}
