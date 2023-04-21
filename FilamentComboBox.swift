//
//  FilamentComboBox.swift
//  3D Print Reg
//
//  Created by RT on 09.04.2023.
//

import Cocoa

class FilamentComboBox: NSComboBox, NSComboBoxDelegate, NSComboBoxDataSource {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.usesDataSource = false
        self.dataSource = self
        
        populate()
    }
    
    func populate() {
        removeAllItems()
        
        for filament in project.filaments {
            var attributesForNonSelectedRow : [NSAttributedString.Key : Any] = [:]
            
            attributesForNonSelectedRow = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 14, weight: NSFont.Weight.semibold), NSAttributedString.Key.foregroundColor: getContrastColor(filament.color), NSAttributedString.Key.backgroundColor: filament.color]
                
            
            let str = NSAttributedString(string: filament.name, attributes: attributesForNonSelectedRow as [NSAttributedString.Key : Any])
            
            
            self.addItem(withObjectValue: str)
        }
                
        self.selectItem(at: 0)
    }
    
    func getContrastColor(_ color: NSColor) -> NSColor {
        var d = 0.0;
        
        let red = 0.299 * color.redComponent
        let green = 0.587 * color.greenComponent
        let blue = 0.114 * color.blueComponent
        
        // Counting the perceptive luminance - human eye favors green color
        if (red + green + blue > 0.5) {
            d = 0; // bright colors - black font
        } else {
            d = 1.0; // dark colors - white font
        }
        
        return NSColor(red: d, green: d, blue: d, alpha: 1)
    }
}
