//
//  RubleFormatter.swift
//  3D Print Reg
//
//  Created by RT on 11.04.2023.
//

import Cocoa

class RubleFormatter: NumberFormatter {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.hasThousandSeparators = false
        self.minimumFractionDigits = 2
        self.minimum = 0
        self.roundingMode = NumberFormatter.RoundingMode.halfDown
        self.positiveFormat = "0.00"
        self.alwaysShowsDecimalSeparator = false
    }
}
