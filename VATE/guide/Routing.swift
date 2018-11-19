//
//  Routing.swift
//  VATE
//
//  Created by Marco Fincato on 15/10/2018.
//  Copyright © 2018 A4Smart. All rights reserved.
//

import Foundation
import os

class Routing {

    public static func getGraph(place: Int) -> Graph {
        let url = getUrl(place: place)
        let data = retrieve(address: url)
        return parse(data: data)
    }
    
    private static func getUrl(place: Int) -> String {
        return "\(Constants.GRAPH_ADDRESS)\(place).json"
    }

    private static func parse(data: Data) -> Graph{
        let graph = Graph()
        var directed : Bool
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        
        if let root = json as? [String: Any] {
            if let jsonGraph = root["graph"] as? [String: Any] {
                
                directed = jsonGraph["directed"] as? Bool ?? false
                
                if let nodes = jsonGraph["nodes"] as? [[String: Any]] {
                    for node in nodes {
                        let name = node["id"] as! Int
                        let uri = node["uri"] as! String
                        graph.addVertex(name: name, uri: uri)
                    }
                }
                
                if let edges = jsonGraph["edges"] as? [[String: Any]] {
                    for edge in edges {
                        let from = edge["from"] as! Int
                        let to = edge["to"] as! Int
                        let weight = edge["weight"] as! Int
                        let dir = edge["dir"] as! Int
                        graph.addEdge(from: from, to: to, weight: weight, dir: dir)
                        if(!directed) {
                            graph.addEdge(from: to, to: from, weight: weight, dir: dir)
                        }
                    }
                }
            }
        }
        
        return graph
    }
    
    private static func retrieve(address: String) -> Data {
        return try! Data(contentsOf: URL(string: address)!)
    }
}
