import EssentialFeed
import UIKit
import EssentialFeediOS

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposeWith(feedLoader: @escaping () -> RemoteLoader<[FeedImage]>.Publisher, imageLoader:  @escaping (URL) -> FeedImageDataLoader.Publisher) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(loader: { feedLoader().dispatchOnMainQueue() })
        
        let feedController = ListViewController()
        feedController.onRefresh = presentationAdapter.didRequestFeedRefresh
        feedController.title = FeedPresenter.title
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(forwardingTo: feedController, imageLoader: { imageLoader($0).dispatchOnMainQueue() }),
            loadingView:  WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map)
        
        return feedController
    }
}
