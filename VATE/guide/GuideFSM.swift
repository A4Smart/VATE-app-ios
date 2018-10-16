//
//  GuideFSM.swift
//  VATE
//
//  Created by Marco Fincato on 15/10/2018.
//  Copyright © 2018 A4Smart. All rights reserved.
//

import Foundation

class GuideFSM {
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

    public func nextMove (minor : Int) -> String {
        var out = "WRONG"

        if (position < 0) {
            if (minor == way[0]) {
                position = 0
                out = "ENTERED THE WAY"
            }
        } else if (position == last) {
            out = "ARRIVED"
        } else {
            if (minor == way[position]) {
                out = "NOT MOVING"
            } else if (minor == way[position + 1]) {
                position+=1
                out = "RIGHT DIRECTION"
            }
        }

        return out

    }

    public func isReady() -> Bool {
        return way != [] && position < last
    }
    
}
