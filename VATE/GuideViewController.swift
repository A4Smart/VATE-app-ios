//
//  GuideViewController.swift
//  VATE
//
//  Created by Marco Fincato on 12/10/2018.
//  Copyright © 2018 A4Smart. All rights reserved.
//

import UIKit
import CoreLocation
import os

class GuideViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        monitorBeacons()
    }
    
    func monitorBeacons() {
        os_log("starting monitoring")
        if CLLocationManager.isMonitoringAvailable(for:CLBeaconRegion.self) {
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
            
            if(major == 42) {
                if (nearestBeacon.proximity == .near || nearestBeacon.proximity == .immediate) {
                        guide(minor: Int(minor))
                }
                else {
                    os_log("detection: minor: %d, proximity: %d", type: .debug, minor, nearestBeacon.proximity.rawValue )
                }
            }
            
        }
    }
    
    let DEWAY = [1, 2, 3, 4]
    
    var dir = 0
    var actPos = 0;
    
    func guide(minor : Int) {
        os_log("guide: minor: %d", type: .debug, minor)
        if (dir == 0) {
            if (minor == DEWAY[0]) {
                dir = 1
                os_log("guide: ENTERED THE WAY")
            }
            else if (minor == DEWAY[DEWAY.count - 1]) {
                actPos = DEWAY.count-1
                dir = -1
                os_log("guide: ENTERED THE YAW")
            }
            else {
                os_log("guide: NOT PART OF WAY")
            }
        } else if (minor == DEWAY[actPos]) {
            os_log("nextStep: NOT MOVING")
        } else if (minor == DEWAY[0] || minor == DEWAY[DEWAY.count - 1]) {
            dir = 0
            os_log("guide: ARRIVED")
        } else if (minor == DEWAY[actPos + dir]) {
            actPos += dir
            os_log("nextStep: RIGHT DIRECTION")
        }  else {
            os_log("nextStep: WRONG")
        }
    }
    
    
}
