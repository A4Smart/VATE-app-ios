//
//  Routing.swift
//  VATE
//
//  Created by Marco Fincato on 15/10/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation
import os

class Routing {

    private static func getUrl(place: Int) -> String {
        return "\(Constants.GRAPH_ADDRESS)\(place).json"
    }
    
    public static func getGraph(place: Int) -> Graph {
        let data = Retriever.getBlocking(address: getUrl(place: place))
        return Parser.parseJson(data: data)
    }
    
}
