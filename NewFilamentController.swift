//
//  NewFilamentController.swift
//  3D Print Reg
//
//  Created by RT on 09.04.2023.
//

import Cocoa

class NewFilamentController: NSViewController {
    @IBOutlet weak var filamentNameText: NSTextField!
    @IBOutlet weak var colorWell: NSColorWell!
    @IBOutlet weak var priceText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirm(_ sender: NSButton) {
        let filament = Filament.init(name: filamentNameText.stringValue, color: colorWell.color.usingColorSpace(NSColorSpace.genericRGB)!, price: priceText.floatValue)
    
        project.filaments.append(filament)
        
        if let mainController = self.presentingViewController as? MainViewController {
            mainController.FilamentsTable.reloadData()
            mainController.PartsTable.reloadData()
        }
        
        self.dismiss(self)
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        self.dismiss(self)
    }
}
