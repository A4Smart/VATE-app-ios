//
//  GuideViewController.swift
//  VATE
//
//  Created by Marco Fincato on 12/10/2018.
//  Copyright © 2018 A4Smart. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import WebKit
import os

class GuideViewController: UIViewController, WKUIDelegate, CLLocationManagerDelegate, WKNavigationDelegate {
    let locationManager = CLLocationManager()
    let guideFSM = GuideFSM()
    let tts = AVSpeechSynthesizer()
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
    
    
    // called when webview is loaded
    // this function will search for the tts text in the webpage,
    // then it will start reading it
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Constants.TTS_SCRIPT) { (result, error) in
            if result != nil {
                let text = String(describing: result.unsafelyUnwrapped)
                if(self.tts.isSpeaking) {
                    self.tts.stopSpeaking(at: AVSpeechBoundary.immediate)
                }
                self.tts.speak(AVSpeechUtterance(string: text))
            }
        }
    }
    
    // starts monitoring for beacon regions
    // when inside a region, ranging is started
    func monitorBeacons() {
        if CLLocationManager.isMonitoringAvailable(for:CLBeaconRegion.self) {
            // Match all beacons with the specified UUID
            let proximityUUID = UUID(uuidString: Constants.VATE_UUID)
            let beaconID = "it.a4smart.beacons"
            
            // Create the region and begin monitoring it.
            let region = CLBeaconRegion(proximityUUID: proximityUUID!, identifier: beaconID)
            self.locationManager.startRangingBeacons(in: region)
        }
    }
    
    
    // called every ranging cycle
    // if a near beacon is found, send value to guide function
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearestBeacon = beacons[0]
            let major = CLBeaconMajorValue(truncating: nearestBeacon.major)
            let minor = CLBeaconMinorValue(truncating: nearestBeacon.minor)
            
            if((major == 42 || major == 10000) && (nearestBeacon.proximity == .near || nearestBeacon.proximity == .immediate)) {
                guide(major: Int(major), minor: Int(minor))
            }
        }
    }
    
    // checks if a guide FSM is created and if a route is defined,
    // then asks the FSM for the next move, and eventually calls load
    private func guide(major: Int, minor: Int) {
        if (!guideFSM.isReady()) {
            let way = Routing.getRoute(place: major, start: minor)
            if (way != []) {
                guideFSM.setWay(way: way)
            }
        } else {
            let act = guideFSM.nextMove(minor: minor)
            if (act == GuideFSM.NEXT || act == GuideFSM.STARTING) {
                load(major: major, minor: minor)
            }
        }
    }
    
    // starts loading the webview
    private func load(major: Int, minor: Int) {
        let myURL = URL(string:"\(Constants.WEB_ADDRESS)\(major)_\(minor)24")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}


// this part is needed to avoid zooming in the webview
extension GuideViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
