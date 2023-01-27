//
//  LocManager.swift
//  Beacon Sample
//
//  Created by Dmitry Vorozhbicki on 27/01/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import CoreLocation

protocol LocManagerDelegate: AnyObject {
    func updated(beacons: [CLProximity: [CLBeacon]])
}

class LocManager: NSObject, CLLocationManagerDelegate {
        
    /**
     This hardcoded UUID appears by default in the ranging prompt.
     It is the same UUID used in ConfigureBeaconViewController
     for creating a beacon.
     */
    let defaultUUID = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

    /// This location manager is used to demonstrate how to range beacons.
    var locationManager = CLLocationManager()
    
    var beaconConstraints = [CLBeaconIdentityConstraint: [CLBeacon]]()
    var beacons = [CLProximity: [CLBeacon]]()
    
    weak var delegate: LocManagerDelegate?
    
    func initManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func start(uuid: UUID) {
        self.locationManager.requestAlwaysAuthorization()
        
        NSLog("Create a new constraint and add it to the dictionary.")
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        self.beaconConstraints[constraint] = []
        
        NSLog("By monitoring for the beacon before ranging, the app is more energy efficient if the beacon is not immediately observable.")
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid.uuidString)
        self.locationManager.startMonitoring(for: beaconRegion)
        self.locationManager.startRangingBeacons(satisfying: constraint)
    }
    
    func stop() {
        // Stop monitoring when the view disappears.
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }

        // Stop ranging when the view disappears.
        for constraint in beaconConstraints.keys {
            locationManager.stopRangingBeacons(satisfying: constraint)
        }
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        NSLog("didVisit: \(visit)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("Exit: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("Enter: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("UPDATE location: \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        NSLog("monitoringDidFailFor: \(region) \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        NSLog("ERROR: \(error)")

    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        NSLog("Start monitoring: \(region)")
        NSLog("man : \(manager)")
        NSLog("beacons: \(beacons) - beaconConstraints \(beaconConstraints)")
    }
    
    /// - Tag: didDetermineState
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let beaconRegion = region as? CLBeaconRegion
        NSLog("DidDetermineState: \(state)")
        if state == .inside {
            NSLog("Start ranging when inside a region")
            manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        } else {
            NSLog("Stop ranging when not inside a region")
            manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        }
    }
    
    /// - Tag: didRange
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        NSLog("didRange \(beacons), \(beaconConstraint)")
        if beacons.count > 0 {
                    NSLog("Found beacon")
                } else {
                    NSLog("Beacon not found")
                }
        beaconConstraints[beaconConstraint] = beacons
        
        self.beacons.removeAll()
        
        var allBeacons = [CLBeacon]()
        
        for regionResult in beaconConstraints.values {
            allBeacons.append(contentsOf: regionResult)
        }
        
        for range in [CLProximity.unknown, .immediate, .near, .far] {
            let proximityBeacons = allBeacons.filter { $0.proximity == range }
            if !proximityBeacons.isEmpty {
                self.beacons[range] = proximityBeacons
            }
        }
        
        DispatchQueue.main.async {
            self.delegate?.updated(beacons: self.beacons)
        }
    }
}
