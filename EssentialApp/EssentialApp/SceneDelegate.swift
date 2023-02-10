//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by mohammadreza on 11/30/22.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import CoreData
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")

    lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    lazy var store: FeedStore & FeedImageDataStore = {
        return try! CoreDataFeedStore(storeURL: localStoreURL)
    }()
    
    private lazy var remoteURL = ImageFeedEndpoint.get.url(baseURL: baseURL)
    
    private lazy var remoteFeedLoader = RemoteLoader(url: remoteURL,
                                                     client: makeRemoteClient(),
                                                     mapper: FeedItemsMapper.map)
    
    private lazy var navigationController: UINavigationController = UINavigationController(rootViewController: FeedUIComposer.feedComposeWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback, selection: showComments))
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
    }
    
    private func showComments(for image: FeedImage) {
        let commentsURL = ImageCommentsEndPoint.get(image.id).url(baseURL: baseURL)
        let comments = CommentsUIComposer.commentsComposeWith(commentsLoader: makeRemoteCommentsLoader(url: commentsURL))
        navigationController.pushViewController(comments, animated: true)
    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
        
        return remoteFeedLoader
            .loadPublisher()
            .cache(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map {
                Paginated(items: $0)
            }.eraseToAnyPublisher()
    }
        
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)

        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: {
                remoteImageLoader
                    .loadImageDataPublisher(from: url)
                    .caching(to: localImageLoader, using: url)
            })
    }
    
    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        let remoteCommentsLoader = RemoteLoader(url: url, client: makeRemoteClient(), mapper: ImageCommentMapper.map)
        return {
            return remoteCommentsLoader
                .loadPublisher()
                .eraseToAnyPublisher()
        }
    }
}

extension RemoteLoader: FeedLoader where Resource == [FeedImage] { }
