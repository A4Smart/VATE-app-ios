//
//  Dijkstra.swift
//  VATE
//
//  Created by Marco Fincato on 11/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation
import os

class Dijkstra {
    private final var predecessors : [Vertex: Vertex]
    private final var distances : [Vertex: Int]
    private final var pq : [Vertex]
    
    init() {
        predecessors =  [Vertex: Vertex]()
        distances =  [Vertex: Int]()
        pq = [Vertex]()
    }
    
    func execute(source: Vertex) {
        var current = source
        pq.append(current)
        distances.updateValue(0, forKey: current)
        while (!pq.isEmpty) {
            current = pq.min(by: { (o1, o2) -> Bool in
                getActDistance(vertex: o1) < getActDistance(vertex: o2)
            })!
            pq.remove(at: pq.firstIndex(of: current)!)
            let adjacent = current.adjacent
            
            for edge in adjacent {
                let target = edge.value.destination
                let oldDist = getActDistance(vertex: target)
                let tempbrtt = getActDistance(vertex: source)
                let newDist = (tempbrtt == Int.max) ? Int.max : tempbrtt
                
                if (oldDist > newDist) {
                    distances.updateValue(newDist, forKey: target)
                    predecessors.updateValue(current, forKey: target)
                    pq.append(target)
                }
            }
        }
    }
    
    func getActDistance(vertex: Vertex) -> Int {
        return distances[vertex] ?? Int.max
    }
    
    func getPath(target: Vertex) -> [Vertex] {
        var path = [Vertex]()
        var step = target
        
        if (predecessors[step] == nil) {
            return []
        }
        path.append(step)
        while (predecessors[step] != nil) {
            step = predecessors[step]!
            path.append(step)
        }
        return path.reversed();
    }
}
