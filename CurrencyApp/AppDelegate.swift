//
//  AppDelegate.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	let storyboardName = "Main"
    var window: UIWindow?
	lazy var rootConnector: ProductsListConnector = {
		ProductsListConnector(entityGateway: InMemoryRepo())
	}()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let navigationController = initializeInitialVC() as! UINavigationController
        let rootVC = navigationController.topViewController as! ProductsTableViewController
		rootConnector.assembleModule(view: rootVC)
        setUpWindow(viewController: navigationController)

		return true
	}

	private func initializeInitialVC() -> UIViewController? {
		let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
		return storyboard.instantiateInitialViewController()
	}

	private func setUpWindow(viewController: UIViewController) {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = viewController
		window?.makeKeyAndVisible()
	}
}

