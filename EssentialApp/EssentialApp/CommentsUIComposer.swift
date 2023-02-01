import EssentialFeed
import UIKit
import EssentialFeediOS
import Combine

public final class CommentsUIComposer {
    private init() {}
    
    public static func commentsComposeWith(commentsLoader: @escaping () -> RemoteLoader<[FeedImage]>.Publisher ) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(
            loader: { commentsLoader().dispatchOnMainQueue()
        })
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = ListViewController(refreshController: refreshController)
        feedController.title = FeedPresenter.title
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                forwardingTo: feedController,
                imageLoader: { _ in  Empty<Data, Error>().eraseToAnyPublisher()  }),
            loadingView:  WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map)
        
        return feedController
    }
}
