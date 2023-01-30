/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main entry point for the application.
*/

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let locationManager = LocManager()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("----> didFinishLaunchingWithOptions")
        locationManager.initManager()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("----> applicationDidBecomeActive")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("----> applicationWillEnterForeground")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("----> applicationDidEnterBackground")
    }
    
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        print("----> didUpdate")
    }
}
