//
//  Part.swift
//  3D Print Reg
//
//  Created by RT on 08.04.2023.
//

import Cocoa


struct Part: Codable {
    var done : Bool = false
    var name : String
    var filamentIndex : Int = -1
    var time : Int?
    var weight : Float?
    
    private var _filamentCost : Float = 0
    
    private enum CodingKeys: String, CodingKey {
            case done, name, filamentIndex, time, weight
    }
    
    var filamentCost : Float {
        get {
            if !project.filaments.isEmpty && filamentIndex >= 0 && filamentIndex < project.filaments.count {
                let filament = project.filaments[filamentIndex]
                return self.weight != nil ? filament.pricePerGramm * self.weight! : 0
            } else {
                return _filamentCost
            }
        }
        
        set {
            _filamentCost = newValue
        }
    }
    
    init(name: String, filamentIndex: Int, time: Int?, weight: Float?) {
        self.name = name
        self.filamentIndex = filamentIndex
        self.time = time
        self.weight = weight
    }
    
    func printCost(timeCost: Float) -> Float {
        return self.time != nil ? (self.filamentCost + Float(self.time!) * timeCost) : 0
    }
    
    func getPrice(timeCost: Float, multiplier: Float) -> Float {
        return printCost(timeCost: timeCost) * multiplier
    }
}
