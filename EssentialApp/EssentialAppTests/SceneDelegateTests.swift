//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {
    
    
    func test_configureSession_makesKeyWindowAndVisible() {
        let window = UIWindowSpy()
        
        let scene = SceneDelegate()
        scene.window = window
        
        scene.configureWindow()
        window.windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1,"Expected window to be key window")
    }
	
	func test_configureWindow_configuresRootViewController() {
		let sut = SceneDelegate()
		sut.window = UIWindow()
		
		sut.configureWindow()
		
		let root = sut.window?.rootViewController
		let rootNavigation = root as? UINavigationController
		let topController = rootNavigation?.topViewController
		
		XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
		XCTAssertTrue(topController is ListViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead")
	}
    
    private class UIWindowSpy: UIWindow {
      var makeKeyAndVisibleCallCount = 0
      override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount = 1
      }
    }
}
