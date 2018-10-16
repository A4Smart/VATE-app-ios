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
    let guideFSM = GuideFSM()
    @IBOutlet weak var textView: UITextView!
    
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
            let proximityUUID = UUID(uuidString: Constants.VATE_UUID)
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
            
            if(major == 42 || major == 10000) {
                if (nearestBeacon.proximity == .near || nearestBeacon.proximity == .immediate) {
                    guide(major: Int(major), minor: Int(minor))
                }
            }
            
        }
    }
    
    private var out = ""

    private func guide(major: Int, minor: Int) {
        if (!guideFSM.isReady()) {
            let way = Routing.getRoute(place: major, start: minor)
            if (way != []) {
                guideFSM.setWay(way: way)
                out = ""
            }
        } else {
            out += "minor: \(minor), guide: \(guideFSM.nextMove(minor: minor))\n"
            textView.text = out;
        }
    }
    
    
}
