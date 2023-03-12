//
//  Models.swift
//  Art Generator
//
//  Created by Jacob Lavenant on 3/11/23.
//

import Foundation

enum Contrants {
    static let imageSize = "256x256"
    static let n = 1
}

struct GenerationInput: Codable {
    var prompt: String
    var n = Contrants.n
    var size = Contrants.imageSize
    
    var encodedData: Data? {
        try? JSONEncoder().encode(self)
    }
}
