//
//  ChecboxCellView.swift
//  3D Print Reg
//
//  Created by RT on 09.04.2023.
//

import Cocoa

class CheckboxCellView: NSTableCellView {

    var row : Int = 0
    
    @IBOutlet weak var checkbox: NSButton!
    
    @IBAction func click(_ sender: NSButton) {
        project.parts[self.row].done = (sender.state == NSControl.StateValue.on)
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("filamentsTableChanged"), object: nil)
    }
}
