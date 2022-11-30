//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by mohammadreza on 11/30/22.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let imageLoader = RemoteFeedImageDataLoader(client: client)
        let feedLoader = RemoteFeedLoader(url: URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!, client: client)
        let feedViewController = FeedUIComposer.feedComposeWith(feedLoader: feedLoader, imageLoader: imageLoader)
        feedViewController.view.backgroundColor = .white
        window?.rootViewController = feedViewController
    }
}

