//
//  FilamentsTable.swift
//  3D Print Reg
//
//  Created by RT on 09.04.2023.
//

import Cocoa

class FilamentsTableView: NSTableView, NSTableViewDelegate, NSTableViewDataSource {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let filament = project.filaments[row]
      
      guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
      
      if (tableColumn?.identifier)!.rawValue == "name" {
          cell.textField?.stringValue = filament.name
      } else if (tableColumn?.identifier)!.rawValue == "color" {
          let colorCell = cell as? ColorCellView
          colorCell!.colorWell.color = filament.color
      } else if (tableColumn?.identifier)!.rawValue == "price" {
          cell.textField?.stringValue = String(filament.price)
      } else if (tableColumn?.identifier)!.rawValue == "colorWell" {
          var a = 100
          a = a*1000
      }
        
      return cell
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return project.filaments.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("filamentsTableChanged"), object: nil)
    }
    
    override func reloadData() {
        super.reloadData()
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("filamentsTableChanged"), object: nil)
    }
}
