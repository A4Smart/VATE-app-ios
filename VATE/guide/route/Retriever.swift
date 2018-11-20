//
//  Retriever.swift
//  VATE
//
//  Created by Marco Fincato on 20/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation

class Retriever {
    public static func getBlocking (address: String) -> Data {
        return try! Data(contentsOf: URL(string: address)!)
    }
}
