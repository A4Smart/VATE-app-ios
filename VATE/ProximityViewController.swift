//
//  ViewController.swift
//  VATE
//
//  Created by Marco Fincato on 08/10/2018.
//  Copyright © 2018 A4Smart. All rights reserved.
//

import UIKit
import os
import CoreLocation


class ProximityViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonHandler(_ sender: UIButton) {
        monitorBeacons()
    }
    
    func monitorBeacons() {
        os_log("starting monitoring")
        if CLLocationManager.isMonitoringAvailable(for:
            CLBeaconRegion.self) {
            // Match all beacons with the specified UUID
            let proximityUUID = UUID(uuidString:
                "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
            let beaconID = "it.a4smart.beacons"
            
            // Create the region and begin monitoring it.
            let region = CLBeaconRegion(proximityUUID: proximityUUID!,
                                        identifier: beaconID)
            self.locationManager.startRangingBeacons(in: region)
            os_log("monitoring started")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        os_log("being called..")
        if region is CLBeaconRegion {
            // Start ranging only if the feature is available.
            if CLLocationManager.isRangingAvailable() {
                os_log("starting ranging")
                manager.startRangingBeacons(in: region as! CLBeaconRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beacons.count > 0 {
            let nearestBeacon = beacons[0]
            let major = CLBeaconMajorValue(truncating: nearestBeacon.major)
            let minor = CLBeaconMinorValue(truncating: nearestBeacon.minor)
            
            os_log("Beacon: %s", type: .debug, "minor: \(minor.description), major: \(major.description)")
        }
    }
    
}

