//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/16/22.
//

import XCTest
@testable import EssentialApp
import EssentialFeediOS

class SceneDelegateTests: XCTestCase {
    
    func test_sceneWillConnectToSession_configuresRootViewController() {
        
        let scene = SceneDelegate()
        scene.window = UIWindow()
        
        scene.configureWindow()
       
        let root = scene.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Excepted a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Excepted a feed view controller as top view controller, got \(String(describing: root)) instead")
    }
    
}
