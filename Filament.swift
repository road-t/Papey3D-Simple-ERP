//
//  Filament.swift
//  3D Print Reg
//
//  Created by RT on 08.04.2023.
//

import Cocoa

struct Filament: Codable {
    var name : String
    var color : NSColor
    var price : Float
    
    var pricePerGramm : Float {
        return self.price / 1000
    }
    
    init(name: String, color: NSColor, price: Float = 0) {
        self.name = name
        self.color = color
        self.price = price
    }
}
