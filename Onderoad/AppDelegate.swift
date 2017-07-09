//
//  AppDelegate.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 17/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	override init() {
		super.init()
		FirebaseApp.configure()
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		GMSPlacesClient.provideAPIKey("AIzaSyAgpF7el0pPO-w8hmdFlmciTRF1_7jwXLc")
		GMSServices.provideAPIKey("AIzaSyAgpF7el0pPO-w8hmdFlmciTRF1_7jwXLc")		
		
		FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
				
		if let currentUser = Auth.auth().currentUser {
			print("User \(currentUser.displayName ?? "") already authenticated!")
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as UIViewController
			self.window?.rootViewController = viewController
		}
		else {
			print("User not authenticated!")
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
			self.window?.rootViewController = viewController
		}
		
		UINavigationBar.appearance().barTintColor = UIColor(red: 102/255, green: 203/255, blue: 255/255, alpha: 1)
		UINavigationBar.appearance().tintColor = UIColor.black
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
		
		UITabBar.appearance().barTintColor = UIColor(red: 102/255, green: 203/255, blue: 255/255, alpha: 1)
		UITabBar.appearance().tintColor = UIColor.black
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		// Call the 'activate' method to log an app event for use
		// in analytics and advertising reporting.
		FBSDKAppEvents.activateApp()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
 
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
	}


}

