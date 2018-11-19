//
//  Directions.swift
//  VATE
//
//  Created by Marco Fincato on 19/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation

class Directions {
    private static let FINISHED = "percorso finito."
    private static let TURN = "gira "
    private static let LEFT = "sinistra."
    private static let RIGHT = "destra."
    private static let KEEP = "prosegui dritto."
    private static let INVERSION = "torna indietro."
    
    
    
    public static func getDirections(edge: Edge?) -> String{
        let dir = edge?.dir ?? 1000
        
        switch dir {
        case 315..<360, 0..<45:
            return KEEP
        case 45..<135:
            return TURN+RIGHT
        case 225..<215:
            return TURN+LEFT
        case 135..<225:
            return INVERSION
        default:
            return FINISHED
        }
    }
}
