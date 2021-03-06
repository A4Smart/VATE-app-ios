//
//  Guide.swift
//  VATE
//
//  Created by Marco Fincato on 21/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation

class Guide {
    let guideFSM = GuideFSM()
    var graph : Graph?
    
    // checks if a guide FSM is created and if a route is defined,
    // then asks the FSM for the next move, and eventually calls load
    func update(major place: Int, minor position : Int) -> Bool {
        if (!guideFSM.isReady) {
            graph = Routing.getGraph(place: place)
            
            // TEMPORARY WORKAROUND
            let destination = (position == 28) ? 1 : 28
            Directions.heading = (position == 28) ? 180 : 0
            // END TEMPORARY WORKAROUND
            
            guideFSM.findWay(graph: graph!, from: position, to: destination)
        }
        let act = guideFSM.nextMove(position: position)
        return act == GuideFSM.NEXT || act == GuideFSM.STARTING
    }
    
    var url : String {
        return guideFSM.url
    }
    
    var indication : String {
        return guideFSM.indication
    }
    
}
