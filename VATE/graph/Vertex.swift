//
//  Vertex.swift
//  VATE
//
//  Created by Marco Fincato on 07/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation

class Vertex : Hashable{
    final var name : Int
    final var uri : String
    final var adjacent : [Int: Edge]
    
    init(name : Int, uri : String) {
        self.name = name
        self.uri = uri
        self.adjacent = [Int: Edge]()
    }
    
    func addNeighbour(edge : Edge) {
        adjacent[edge.destination.name] = edge
    }
    
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.name == rhs.name && lhs.uri == rhs.uri
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(uri)
    }
    
    var description: String {
        return "Name: \(name)"
    }
    
}
