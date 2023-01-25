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
    
    func test_configureSession_makesKeyWindowAndVisible() {
        let window = UIWindowSpy()
        
        let scene = SceneDelegate()
        scene.window = window
        
        scene.configureWindow()
        window.windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1,"Expected window to be key window")
    }
    
    func test_sceneWillConnectToSession_configuresRootViewController() {
        
        let scene = SceneDelegate()
        scene.window = UIWindow()
        
        scene.configureWindow()
       
        let root = scene.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Excepted a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is ListViewController, "Excepted a feed view controller as top view controller, got \(String(describing: root)) instead")
    }
    
    private class UIWindowSpy: UIWindow {
      var makeKeyAndVisibleCallCount = 0
      override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount = 1
      }
    }
}
