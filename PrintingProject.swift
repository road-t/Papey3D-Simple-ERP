//
//  PrintingProject.swift
//  3D Print Reg
//
//  Created by RT on 08.04.2023.
//

import Cocoa

class PrintingProject: Codable {
    
    var orderNumber : String
    var timeCost : Float
    var costMultiplier : Float
    var tax : Float
    
    var filaments: [Filament] = []
    var parts: [Part] = []
    
    var total: Part {
        var totalPart = Part(name: "Total", filamentIndex: -1, time: 0, weight: 0)
        
        var isDone = true
        
        for part in parts {
            totalPart.time! += part.time!
            totalPart.weight! += part.weight!
            totalPart.filamentCost += part.filamentCost
            
            if !part.done {
                isDone = false
            }
        }
        
        totalPart.done = isDone
        
        return totalPart
    }
    
    init(timeCost: Float = 3, costMultiplier: Float = 2, tax: Float = 4) {
        self.timeCost = timeCost
        self.costMultiplier = costMultiplier
        self.tax = tax
        
        let df = DateFormatter()
        df.dateFormat = "yyMM"
        
        let date = df.string(from: Date())
        
        self.orderNumber = "\(date)000000"
    }
}
