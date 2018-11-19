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
    
    private var way : [Vertex]
    private var position : Int
    private var last : Int
    private var graph : Graph?
    
    init() {
        way = []
        position = 0
        last = 0
    }

    public func findWay(graph : Graph, from: Int, to: Int) {
        self.graph = graph
        self.way = graph.getShortestPath(from: from, to: to)
        position = -1
        last = way.endIndex - 1
    }

    public func nextMove (minor : Int) -> Int {
        if (position < 0) {
            if (minor == way[0].name) {
                position = 0
                return GuideFSM.STARTING
            }
        } else if (position == last) {
            return GuideFSM.END
        } else {
            if (minor == way[position].name) {
                return GuideFSM.IDLING
            } else if (minor == way[position + 1].name) {
                position+=1
                return GuideFSM.NEXT
            }
        }
        return GuideFSM.WRONG
    }

    var ready: Bool {
        return way != [] && position < last
    }
    
    var url: String {
        return way[position].uri + "24"
    }
    
    var indication: String {
        let edge = graph?.getEdge(from: way[position], to: way[position+1])
        return Directions.getDirections(edge: edge ?? nil)
    }
}
