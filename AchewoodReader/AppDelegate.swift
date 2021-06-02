//
//  AppDelegate.swift
//  AchewoodReader
//
//  Created by eric on 2020/12/14.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow()
		guard let unwrappedWindow = self.window else { fatalError() }
		unwrappedWindow.backgroundColor = .white
		let initialViewController = HomePageViewController()
		unwrappedWindow.rootViewController = initialViewController
		unwrappedWindow.makeKeyAndVisible()
		
		return true
	}
}
