/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main entry point for the application.
*/

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LocManagerDelegate {
    var locationManager = LocManager()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.initManager()
        locationManager.delegate = self
        locationManager.start(uuid: UUID(uuidString: locationManager.defaultUUID)!)
        return true
    }
    
    func updated(beacons: [CLProximity : [CLBeacon]]) {
        print("----> \(beacons)")
    }
}
