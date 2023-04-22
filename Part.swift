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
    var filaments : [Material] = []
    var time : Int
    
    private var _filamentCost : Float = 0
    private var _weight : Float = 0
    
    private enum CodingKeys: String, CodingKey {
            case done, name, filaments, time
    }
    
    var filamentCost : Float {
        get {
            var cost : Float = 0
            
            for filament in filaments {
                if filament.index >= 0 && filament.index < project.filaments.count {
                    cost += project.filaments[filament.index].pricePerGramm * filament.weight
                }
            }
            
            return cost > 0 ? cost : _filamentCost
        }
        
        set {
            _filamentCost = newValue
        }
    }
    
    var weight : Float {
        get {
            var totalWeight : Float = 0
            
            for filament in filaments {
                if filament.index >= 0 && filament.index < project.filaments.count {
                    totalWeight += filament.weight
                }
            }
            
            return totalWeight > 0 ? totalWeight : _weight
        }
        
        set {
            _weight = newValue
        }
    }
    
    init(name: String, filaments: [Material], time: Int) {
        self.name = name
        self.filaments = filaments
        self.time = time
    }
    
    func printCost(timeCost: Float) -> Float {
        return self.filamentCost + Float(self.time) * timeCost
    }
    
    func getPrice(timeCost: Float, multiplier: Float) -> Float {
        return printCost(timeCost: timeCost) * multiplier
    }
}
