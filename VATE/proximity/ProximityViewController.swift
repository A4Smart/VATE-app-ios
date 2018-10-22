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
import AVFoundation
import WebKit

class ProximityViewController: UIViewController, WKUIDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let tts = AVSpeechSynthesizer()
    var oldMinor = -1
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        view = webView
        
        //setup location
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        //start monitoring for beacons
        monitorBeacons()
    }
    
    // starts monitoring for beacon regions
    // when inside a region, ranging is started
    func monitorBeacons() {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            // Match all beacons with the specified UUID
            let proximityUUID = UUID(uuidString: Constants.VATE_UUID)
            let beaconID = "it.a4smart.beacons"
            
            // Create the region and begin monitoring it.
            let region = CLBeaconRegion(proximityUUID: proximityUUID!, identifier: beaconID)
            self.locationManager.startRangingBeacons(in: region)
        }
    }
    
    // called every ranging cycle
    // if a new near beacon is found, calls loadBeacon to show webview
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearestBeacon = beacons[0]
            let major = Int(CLBeaconMajorValue(truncating: nearestBeacon.major))
            let minor = Int(CLBeaconMinorValue(truncating: nearestBeacon.minor))
            
            if((nearestBeacon.proximity == .near || nearestBeacon.proximity == .immediate) && minor != oldMinor ) {
                os_log("Beacon: %s", type: .debug, "minor: \(minor), major: \(major)")
                oldMinor = minor
                loadBeacon(minor: minor, major: major)
            }
        }
    }
    
    // starts loading the webview
    func loadBeacon(minor : Int, major : Int) {
        let myURL = URL(string:"\(Constants.WEB_ADDRESS)\(major)_\(minor)")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}


// this part is needed to avoid zooming in the webview
extension ProximityViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
