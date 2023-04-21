//
//  ColorCellView.swift
//  3D Print Reg
//
//  Created by RT on 09.04.2023.
//

import Cocoa

class ColorCellView: NSTableCellView {

    @IBOutlet weak var colorWell: NSColorWell!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
