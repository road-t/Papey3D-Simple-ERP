//
//  NewPartViewController.swift
//  3D Print Reg
//
//  Created by RT on 09.04.2023.
//

import Cocoa

class NewPartViewController: NSViewController {

    @IBOutlet weak var partNameText: NSTextField!
    
    @IBOutlet weak var filamentCombo0: NSComboBox!
    @IBOutlet weak var filamentCombo1: NSComboBoxCell!
    
    @IBOutlet weak var weightText0: NSTextField!
    @IBOutlet weak var weightText1: NSTextField!
    
    @IBOutlet weak var timeText: NSTextField!
    
    var editedPartIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard editedPartIndex != nil, editedPartIndex! >= 0, editedPartIndex! < project.parts.count else {
            self.title = "Add new part"
            
            return
        }
        
        self.title = "Edit part"
        
        let editedPart = project.parts[editedPartIndex!]
        
        partNameText.stringValue = editedPart.name
        
        filamentCombo0.selectItem(at: editedPart.filaments[0].index)
        weightText0.floatValue = editedPart.filaments[0].weight
        
        if editedPart.filaments.count > 1 {
            filamentCombo1.selectItem(at: editedPart.filaments[1].index)
            weightText1.floatValue = editedPart.filaments[1].weight
        }
        
        timeText.integerValue = editedPart.time
    }
    
    @IBAction func confirm(_ sender: NSButton) {
        var filaments : [Material] = []
        
        if filamentCombo0.indexOfSelectedItem >= 0 && weightText0.floatValue > 0 {
            filaments.append(Material(index: filamentCombo0.indexOfSelectedItem, weight: weightText0.floatValue))
        }
        
        if filamentCombo1.indexOfSelectedItem >= 0 && weightText1.floatValue > 0 {
            filaments.append(Material(index: filamentCombo1.indexOfSelectedItem, weight: weightText1.floatValue))
        }
        
        if editedPartIndex == nil {
            let part = Part.init(name: partNameText.stringValue, filaments: filaments, time: timeText.integerValue)
            
            project.parts.append(part)
        } else {
            project.parts[editedPartIndex!].name = partNameText.stringValue
            project.parts[editedPartIndex!].filaments = filaments
            project.parts[editedPartIndex!].time = timeText.integerValue
        }
        
        if let mainController = self.presentingViewController as? MainViewController {
            mainController.PartsTable.reloadData()
        }
        
        self.dismiss(self)
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        self.dismiss(self)
    }
}
