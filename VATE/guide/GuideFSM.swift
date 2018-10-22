//
//  GuideFSM.swift
//  VATE
//
//  Created by Marco Fincato on 15/10/2018.
//  Copyright © 2018 A4Smart. All rights reserved.
//

import Foundation

class GuideFSM {
    public static let WRONG = -1
    public static let IDLING = 0
    public static let STARTING = 1
    public static let NEXT = 2
    public static let END = 3
    
    private var way : [Int]
    private var position : Int
    private var last : Int
    
    init() {
        way = []
        position = 0
        last = 0
    }

    public func setWay(way : [Int]) {
        self.way = way
        position = -1
        last = way.endIndex - 1
    }

    public func nextMove (minor : Int) -> Int {
        if (position < 0) {
            if (minor == way[0]) {
                position = 0
                return GuideFSM.STARTING
            }
        } else if (position == last) {
            return GuideFSM.END
        } else {
            if (minor == way[position]) {
                return GuideFSM.IDLING
            } else if (minor == way[position + 1]) {
                position+=1
                return GuideFSM.NEXT
            }
        }
        return GuideFSM.WRONG
    }

    public func isReady() -> Bool {
        return way != [] && position < last
    }
    
}
