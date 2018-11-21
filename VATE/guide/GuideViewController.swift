//
//  GuideViewController.swift
//  VATE
//
//  Created by Marco Fincato on 12/10/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import WebKit
import os

class GuideViewController: UIViewController, CLLocationManagerDelegate, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    let locationManager = CLLocationManager()
    let guideFSM = GuideFSM()
    let tts = AVSpeechSynthesizer()
    var graph : Graph?
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.navigationDelegate = self;
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
        if CLLocationManager.isMonitoringAvailable(for:CLBeaconRegion.self) {
            // Match all beacons with the specified UUID
            let proximityUUID = UUID(uuidString: Constants.VATE_UUID)
            let beaconID = "it.a4smart.beacons"
            
            // Create the region and begin monitoring it.
            let region = CLBeaconRegion(proximityUUID: proximityUUID!, identifier: beaconID)
            locationManager.startRangingBeacons(in: region)
        }
    }
    
    // checks if a guide FSM is created and if a route is defined,
    // then asks the FSM for the next move, and eventually calls load
    private func guide(major: Int, minor: Int) {
        if (!guideFSM.isReady) {
            graph = Routing.getGraph(place: major)
            
            // TEMPORARY WORKAROUND
            let destination = (minor == 28) ? 1 : 28
            // END TEMPORARY WORKAROUND
            
            guideFSM.findWay(graph: graph!, from: minor, to: destination)
        } else {
            let act = guideFSM.nextMove(minor: minor)
            if (act == GuideFSM.NEXT || act == GuideFSM.STARTING) {
                load(url: guideFSM.url)
            }
        }
    }
    
    // starts loading the webview
    private func load(url: String) {
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func speak(text: String, indication: String) {
        if(self.tts.isSpeaking) {
            self.tts.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        self.tts.speak(AVSpeechUtterance(string: text))
        self.tts.speak(AVSpeechUtterance(string: indication))
        
    }
    
    // INHERITED METHODS
    
    // called every ranging cycle
    // if a near beacon is found, send value to guide function
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearest = beacons[0]
            let major = nearest.major.intValue
            let minor = nearest.minor.intValue
            
            if(nearest.isGuidance && nearest.isNear) {
                guide(major: major, minor: minor)
            }
        }
    }
    
    // called when webview is loaded
    // this function will search for the tts text in the webpage,
    // then it will start reading it
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Constants.TTS_SCRIPT) { (result, error) in
            if result != nil {
                let text = String(describing: result.unsafelyUnwrapped)
                self.speak(text: text, indication: self.guideFSM.indication)
            }
        }
    }
    
    // called when the user tries to zoom
    // if the user begins zooming the function avoid it by disabling the pinch gesture
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
}

extension CLBeacon {
    var isNear: Bool {
        return proximity == .near || proximity == .immediate
    }
    
    var isGuidance: Bool {
        return [42, 10000].contains(major)
    }
}
