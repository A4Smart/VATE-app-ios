//
//  ViewController.swift
//  VateApp
//
//  Created by Handing  on 17/04/18.
//  Copyright © 2018 Handing . All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, BeaconInterfaceDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tempLabel: UILabel!
    
    fileprivate var myInterface = DemoBeaconInterface()
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        myInterface.getBeacons(completionHandler: <#T##(([HandiBeacon]) -> Void)?##(([HandiBeacon]) -> Void)?##([HandiBeacon]) -> Void#>)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("N Beacons: "+String(myInterface.beaconList.count))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func beaconInterface(didChangeBeacons beacons: [HandiBeacon]) {
        print("Ciao")
        
        if beacons.isEmpty{
            return
        }
        
        if let firstBeac = beacons.first{
            let tempText = "NearBeac - majo: "+String(firstBeac.major)+", minor: "+String(firstBeac.minor)
            //tempLabel.text(tempText)
            print(tempText)
            
            let myLink = "https://vateapp.eu/10000_"+String(firstBeac.minor)
            
            let myURL = URL(string: myLink)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
    


}

