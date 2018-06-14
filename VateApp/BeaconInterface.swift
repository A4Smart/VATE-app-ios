//
//  BeaconInterface.swift
//  VateApp
//
//  Created by Handing  on 24/05/18.
//  Copyright © 2018 Handing . All rights reserved.
//
import Foundation
import UIKit


protocol BeaconInterfaceDelegate: class {
    
    /**
     Updates the delegate when the beacons within range have changed or have updated information.
     
     - parameter beaconInterface: `BeaconInterface` calling the delegate.
     - parameter beacons:         New and/or updated array of `WAYBeacon` nearby.
     */
    func beaconInterface( didChangeBeacons beacons: [HandiBeacon])
}

final class DemoBeaconInterface: NSObject, ESTBeaconManagerDelegate {
    
    // MARK: - Properties
    weak var delegate: BeaconInterfaceDelegate?
    
    /// List of valid beacons that the `BeaconInterface` use for filtering.
    var beaconList = [HandiBeacon]()
    
    //GIACOMO
    let beaconManager = ESTBeaconManager()
    let locationManager = CLLocationManager()
    
    let beaconRegion = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,  /*major: 200,*/
        identifier: "ranged region")
    let ufficio = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major:5000,
        identifier: "san marco")
    
    // MARK: - Initializers
    
    init(_: String = "bla") {
        super.init()
        
        print("Interface init")
        self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestAlwaysAuthorization()
        
        self.beaconManager.startRangingBeacons(in: self.ufficio)
    }
    
    
    // MARK: - GET
    
    //LETTURA SEGNALE BEACON
    func beaconManager( _ manager: Any, didRangeBeacons beacons: [CLBeacon],
                        in region: CLBeaconRegion) {
        
        //DEFINIZIONE ARRAY DI WAYBEACON
        //qui viene creato l'oggetto WAYBeacon per ciascun beacon trovato
        beaconList.removeAll()
        
        for beacon in beacons {
            //let newBeacon = WAYBeacon(beacon: beacon) era così
            let newBeacon = HandiBeacon(beacon: beacon, advertisingInterval: nil, batteryLevel: nil, lastUpdated: nil, txPower: nil)
            
            beaconList.append(newBeacon)
        }
        
        print("Sto leggendo "+String(beaconList.count)+" beacons")

        if !beaconList.isEmpty {
            delegate?.beaconInterface(didChangeBeacons: beaconList)
            print("Sto chiamando il delegate")
        }
        
    }
    //END GIACOMO
    func getBeacons(completionHandler: (([HandiBeacon]) -> Void)?) {
        completionHandler?(beaconList)
    }
    
}


