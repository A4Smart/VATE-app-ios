//
//  Edge.swift
//  VATE
//
//  Created by Marco Fincato on 07/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation

class Edge {
    final var source : Vertex
    final var destination : Vertex
    final var weight : Int
    final var dir : Int
    
    init(source : Vertex, destination : Vertex, weight : Int, dir : Int) {
        self.source = source
        self.destination = destination
        self.weight = weight
        self.dir = dir
    }
}
