import EssentialFeed
import UIKit
import EssentialFeediOS
import Combine

public final class CommentsUIComposer {
    private init() {}
    
    public static func commentsComposeWith(commentsLoader: @escaping () -> RemoteLoader<[ImageComment]>.Publisher ) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentViewAdapter>(
            loader: { commentsLoader().dispatchOnMainQueue()
        })
        let commentController = ListViewController()
        commentController.onRefresh = presentationAdapter.loadResource
        commentController.title = ImageCommentPresenter.title
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentViewAdapter(
                forwardingTo: commentController),
            loadingView:  WeakRefVirtualProxy(commentController),
            errorView: WeakRefVirtualProxy(commentController),
            mapper: { ImageCommentPresenter.map($0) })
        
        return commentController
    }
}

public final class CommentViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(forwardingTo controller: ListViewController) {
        self.controller = controller
    }
    
    public func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            return CellController(ImageCommentCellController(model: viewModel))
        })
    }
}

private struct InvalidImageDataError: Error {   }
