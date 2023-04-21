//
//  PartsTableViewController.swift
//  3D Print Reg
//
//  Created by RT on 08.04.2023.
//

import Cocoa

class PartsTableView : NSTableView, NSTableViewDelegate, NSTableViewDataSource {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let isRegularRow = row < project.parts.count
        let part = isRegularRow ? project.parts[row] : project.total
      
      guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        
      if (tableColumn?.identifier)!.rawValue == "name" {
          cell.textField?.stringValue = part.name
          
          cell.textField?.isEditable = isRegularRow
      } else if (tableColumn?.identifier)!.rawValue == "filament" {
          if let fcbCell = cell as? FilamentComboBoxCell {
              
              if part.filamentIndex >= 0 {
                  fcbCell.filamentComboBox.populate()
                  fcbCell.filamentComboBox.selectItem(at: part.filamentIndex)
              } else {
                  fcbCell.isHidden = true
              }
          }
      } else if (tableColumn?.identifier)!.rawValue == "time" {
          if let minutes = part.time {
              let time = (minutes / 60, (minutes % 60))
              cell.textField?.stringValue = String(format: "%02d:%02d", time.0, time.1)
          }
          
          cell.textField?.isEditable = isRegularRow
      } else if (tableColumn?.identifier)!.rawValue == "weight" {
          cell.textField?.stringValue = part.weight != nil ? String(part.weight!) : "0"
          
          cell.textField?.isEditable = isRegularRow
      } else if (tableColumn?.identifier)!.rawValue == "filamentCost" {
          cell.textField?.stringValue = String(part.filamentCost)
      } else if (tableColumn?.identifier)!.rawValue == "totalCost" {
          cell.textField?.stringValue = part.time != nil ? String(part.filamentCost + Float(part.time!) * project.timeCost) : "0"
      } else if (tableColumn?.identifier)!.rawValue == "sum" {
          cell.textField?.stringValue = part.time != nil ? String((part.filamentCost + Float(part.time!) * project.timeCost) * project.costMultiplier) : "0"
      } else if (tableColumn?.identifier)!.rawValue == "price" {
          cell.textField?.stringValue = part.time != nil ? String((part.filamentCost + Float(part.time!) * project.timeCost) * project.costMultiplier * (1 + project.tax /  100)) : "0"
      } else if (tableColumn?.identifier)!.rawValue == "done" {
          if let cbCell = cell as? CheckboxCellView {
              
              cbCell.row = row
              
              if  part.done {
                  cbCell.checkbox.state = NSControl.StateValue.on
                  
                  self.rowView(atRow: row, makeIfNecessary: false)?.backgroundColor = NSColor(red: 0.7, green: 1.0, blue: 0.5, alpha: 1.0)
              } else {
                  cbCell.checkbox.state = NSControl.StateValue.off
                  
                  self.rowView(atRow: row, makeIfNecessary: false)?.backgroundColor = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
              }
              
              cbCell.checkbox.isEnabled = isRegularRow
          }
      }
      
      return cell
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return project.parts.count > 0 ? project.parts.count + 1 : 0
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("partsTableChanged"), object: nil)
    }
    
    override func reloadData() {
        super.reloadData()
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("partsTableChanged"), object: nil)
    }
}
