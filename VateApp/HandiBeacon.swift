//
//  HandiBeacon.swift
//  VateApp
//
//  Created by Handing  on 24/05/18.
//  Copyright © 2018 Handing . All rights reserved.
//

import Foundation

import Foundation
import CoreLocation

/**
 *  Manufacturer and implementation independent representation of a beacon.
 */
class HandiBeacon {
    
    enum ValueKeys: String {
        case Major                  = "major"
        case Minor                  = "minor"
        case UUID                   = "uuid"
        case Accuracy               = "accuracy"
        case Rssi                   = "rssi"
        
        static let allValues = [Major, Minor, UUID, Accuracy, Rssi]
    }
    
    // MARK: - Required Properties
    
    /// Major value for the associated beacon.
    let major: Int
    /// Minor value for the associated beacon.
    let minor: Int
    /// UUID string identifying the beacon.
    let UUIDString: String
    
    // MARK: - Optional Properties
    
    /// Accuracy of coodinate values in meters (m).
    let accuracy: CLLocationAccuracy?
    /// Advertising interval of the beacon in milliseconds (ms).
    let advertisingInterval: String?
    /// Battery level of the beacon rounded to the nearest percent (%).
    let batteryLevel: String?
    /// The last time the data for the beacon was updated.
    let lastUpdated: Date?
    /// Received signal strength indicator measured in decible-milliwatts (dBm).
    var rssi: Int?
    /// Rssi List
    var rssiList = [Int]()
    /// Relative indicator of transmission power level.
    let txPower: String?
    
    // MARK: - Initializers
    
    /**
     Initializes a `WAYBeacon`.
     
     - parameter major:               Major value for the associated beacon.
     - parameter minor:               Minor value for the associated beacon.
     - parameter UUIDString:          UUID string identifying the beacon.
     - parameter accuracy:            Accuracy of coodinate values in meters (m).
     - parameter advertisingInterval: Advertising interval of the beacon in milliseconds (ms).
     - parameter batteryLevel:        Battery level of the beacon rounded to the nearest percent (%).
     - parameter lastUpdated:         The last time the data for the beacon was updated.
     - parameter rssi:                Received signal strength indicator measured in decible-milliwatts (dBm).
     - parameter shortID:             Optional short identifier to use as separate from the `UUIDString`.
     - parameter txPower:             Relative indicator of transmission power level.
     */
    init(major: Int, minor: Int, UUIDString: String, accuracy: CLLocationAccuracy? = nil, advertisingInterval: String? = nil, batteryLevel: String? = nil, lastUpdated: Date? = nil, rssi: Int? = nil, txPower: String? = nil) {
        self.accuracy = accuracy
        self.advertisingInterval = advertisingInterval
        self.batteryLevel = batteryLevel
        self.lastUpdated = lastUpdated
        self.major = major
        self.minor = minor
        self.rssi = rssi
        self.txPower = txPower
        self.UUIDString = UUIDString
        
        rssiList.append(rssi!)
    }
    
    /**
     Initializes a `WAYBeacon` from a `CLBeacon` object.
     
     - parameter beacon:              `CLBeacon` object to use as foundation of the `WAYBeacon`.
     - parameter advertisingInterval: Advertising interval of the beacon in milliseconds (ms).
     - parameter batteryLevel:        Battery level of the beacon rounded to the nearest percent (%).
     - parameter lastUpdated:         The last time the data for the beacon was updated.
     - parameter shortID:             Optional short identifier to use as separate from the `UUIDString`.
     - parameter txPower:             Relative indicator of transmission power level.
     */
    init(beacon: CLBeacon, advertisingInterval: String? = nil, batteryLevel: String? = nil, lastUpdated: Date? = nil, txPower: String? = nil) {
        self.accuracy = beacon.accuracy
        self.major = Int(beacon.major)
        self.minor = Int(beacon.minor)
        self.rssi = beacon.rssi
        self.UUIDString = beacon.proximityUUID.uuidString
        
        self.advertisingInterval = advertisingInterval
        self.batteryLevel = batteryLevel
        self.lastUpdated = lastUpdated
        self.txPower = txPower
        
        rssiList.append(rssi!)

        
    }
    
}
