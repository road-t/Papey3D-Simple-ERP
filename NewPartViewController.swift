//
//  NewPartViewController.swift
//  3D Print Reg
//
//  Created by RT on 09.04.2023.
//

import Cocoa

class NewPartViewController: NSViewController {

    @IBOutlet weak var partNameText: NSTextField!
    @IBOutlet weak var filamentCombo: NSComboBox!
    @IBOutlet weak var weightText: NSTextField!
    @IBOutlet weak var timeText: NSTextField!
    
    @IBAction func confirm(_ sender: NSButton) {
        let filament = filamentCombo.indexOfSelectedItem
    
        let part = Part.init(name: partNameText.stringValue, filamentIndex: filament, time: timeText.integerValue, weight: weightText.floatValue)
        
        project.parts.append(part)
        
        if let mainController = self.presentingViewController as? MainViewController {
            mainController.PartsTable.reloadData()
        }
        
        self.dismiss(self)
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        self.dismiss(self)
    }
}
