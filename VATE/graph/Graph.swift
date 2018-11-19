//
//  Graph.swift
//  VATE
//
//  Created by Marco Fincato on 11/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation

class Graph {
    private final var vertexes : [Int: Vertex]
    
    init() {
        self.vertexes = [Int: Vertex]()
    }
    
    func addVertex(name: Int, uri: String) {
        vertexes[name] = Vertex(name: name, uri: uri)
    }
    
    func addEdge(from: Int, to: Int, weight: Int, dir: Int) {
        let edge = Edge(source: vertexes[from]!, destination: vertexes[to]!, weight: weight, dir: dir)
        vertexes[from]?.addNeighbour(edge: edge)
    }
    
    func getVertex(name: Int) -> Vertex {
        return vertexes[name]!
    }
    
    func getEdge(from: Vertex, to: Vertex) -> Edge? {
        return vertexes[from.name]?.adjacent[to.name]
    }
    
    func getShortestPath(from: Int, to: Int) -> [Vertex] {
        let dijkstra = Dijkstra()
        dijkstra.execute(source: vertexes[from]!)
        return dijkstra.getPath(target: vertexes[to]!)
    }
}
