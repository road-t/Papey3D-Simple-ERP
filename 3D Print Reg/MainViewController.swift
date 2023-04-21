//
//  ViewController.swift
//  3D Print Reg
//
//  Created by RT on 08.04.2023.
//

import Cocoa

var project : PrintingProject = PrintingProject.init()

class MainViewController: NSViewController, NSTextFieldDelegate, NSTableViewDataSource {

    @IBOutlet weak var OrderNumberText: NSTextField!
    @IBOutlet weak var PartsTable: PartsTableView!
    @IBOutlet weak var FilamentsTable: FilamentsTableView!
    
    @IBOutlet weak var CostMultiplierText: NSTextField!
    @IBOutlet weak var TaxValueText: NSTextField!
    @IBOutlet weak var TimeCostText: NSTextField!
    
    @IBOutlet weak var SaveButton: NSButton!
    @IBOutlet weak var removePartButton: NSButton!
    @IBOutlet weak var addPartButton: NSButton!
    @IBOutlet weak var addFilamentButton: NSButton!
    @IBOutlet weak var removeFilamentButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // update parts table on coefficients change
        self.TimeCostText.delegate = self
        self.CostMultiplierText.delegate = self
        self.TaxValueText.delegate = self
        self.OrderNumberText.delegate = self
        
        OrderNumberText.stringValue = project.orderNumber
        
        addPartButton.isEnabled = false
        removePartButton.isEnabled = false
        removeFilamentButton.isEnabled = false
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(partsTableChanged), name: Notification.Name("partsTableChanged"), object: nil)
        nc.addObserver(self, selector: #selector(filamentsTableChanged), name: Notification.Name("filamentsTableChanged"), object: nil)
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    func controlTextDidChange(_ notification: Notification) {

        if let textField = notification.object as? NSTextField {
            switch (textField) {
                
            case OrderNumberText:
                project.orderNumber = OrderNumberText.stringValue
                break;
                
            case TimeCostText:
                project.timeCost = TimeCostText.floatValue
                break;
            
            case CostMultiplierText:
                project.costMultiplier = CostMultiplierText.floatValue
                break;
            
            case TaxValueText:
                project.tax = TaxValueText.floatValue
                break;
                
            default:
                let a = 0
            }
            
            PartsTable.reloadData()
        }
    }
    
    @IBAction func editPart(_ sender: Any) {
        if let editedTextField = sender as? NSTextField {
            let row = PartsTable.row(for: editedTextField)
            
            if 0..<project.parts.count ~= row { // prevent crash
                let columnIndex = PartsTable.column(for: editedTextField)
                
                let column = PartsTable.tableColumns[columnIndex]
                
                if column.identifier.rawValue == "name" {
                    project.parts[row].name = editedTextField.stringValue
                } else if column.identifier.rawValue == "time" {
                    project.parts[row].time = editedTextField.integerValue
                } else if column.identifier.rawValue == "weight" {
                    project.parts[row].weight = editedTextField.floatValue
                } else if let filamentComboBox = sender as? FilamentComboBox {
                    let row = PartsTable.row(for: filamentComboBox)
                    
                    project.parts[row].filamentIndex = filamentComboBox.indexOfSelectedItem
                }
                
                PartsTable.reloadData(forRowIndexes: [row], columnIndexes: [2, 6, 7, 8])
            }
        }
    }
    
    @IBAction func editFilament(_ sender: Any) {
        if let editedTextField = sender as? NSTextField {
            let row = FilamentsTable.row(for: editedTextField)
            let columnIndex = FilamentsTable.column(for: editedTextField)
            
            let column = FilamentsTable.tableColumns[columnIndex]
            
            if column.identifier.rawValue == "name" {
                project.filaments[row].name = editedTextField.stringValue
            } else if column.identifier.rawValue == "price" {
                project.filaments[row].price = editedTextField.floatValue
            }
        } else if let colorWell = sender as? NSColorWell {
            let row = FilamentsTable.row(for: colorWell)
            
            project.filaments[row].color = colorWell.color
        }
        
        PartsTable.reloadData()
    }
   
    @IBAction func removePart(_ sender: Any) {
        let selected = PartsTable.selectedRow
        
        if selected != -1 {
            project.parts.remove(at: selected)
            PartsTable.removeRows(at: [selected], withAnimation: NSTableView.AnimationOptions.slideUp)
            PartsTable.reloadData()
        }
    }
    
    @IBAction func removeFilament(_ sender: Any) {
        let selected = FilamentsTable.selectedRow
        
        if selected != -1 {
            project.filaments.remove(at: selected)
            FilamentsTable.removeRows(at: [selected], withAnimation: NSTableView.AnimationOptions.slideUp)
        }
        
        filamentsTableChanged()
    }
    
    @IBAction func saveProject(_ sender: Any) {
        let panel = NSSavePanel()
        
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
        panel.nameFieldStringValue = project.orderNumber + ".p3d" //thisFileURL.lastPathComponent
        panel.title                   = "Save project"
        panel.showsResizeIndicator    = true
        panel.showsHiddenFiles        = false
        panel.canCreateDirectories    = true
        panel.allowedFileTypes      = ["p3d"]
        
        if (panel.runModal() == NSApplication.ModalResponse.OK), let saveFileURL = panel.url  {
            
            do {
                guard let data = try? JSONEncoder().encode(project) else { return }
                
                print(data)
                
                try data.write(to: saveFileURL)
            } catch {
              //  self.myAppManager.displayInfoAlert("Unable to save file:\n\(error.localizedDescription)", self, [], false, response: {(bResponse:Bool) in })
                
                print("Failed to write file((")
            }
        }
    }
    
    @IBAction func loadProject(_ sender: Any) {
        let panel = NSOpenPanel()
        
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
        panel.title                   = "Open project";
        panel.showsResizeIndicator    = true;
        panel.showsHiddenFiles        = false;
        panel.canCreateDirectories    = false;
        panel.allowedFileTypes      = ["p3d"]
        
        if (panel.runModal() == NSApplication.ModalResponse.OK), let fileURL = panel.url  {
            
            do {
                guard let json = try? Data(contentsOf: fileURL) else { return }
                
                let decoder = JSONDecoder()

                if let loadedProject = try? decoder.decode(PrintingProject.self, from: json) {
                    
                    project = loadedProject
                    
                    OrderNumberText.stringValue = project.orderNumber
                    TaxValueText.floatValue = project.tax
                    TimeCostText.floatValue = project.timeCost
                    CostMultiplierText.floatValue = project.costMultiplier
                    
                    FilamentsTable.reloadData()
                    PartsTable.reloadData()
                }
                
            } catch {
                
              //  self.myAppManager.displayInfoAlert("Unable to save file:\n\(error.localizedDescription)", self, [], false, response: {(bResponse:Bool) in })
                
                print("Failed to read file((")
            }
        }
    }
    
    @objc func partsTableChanged() {
        removePartButton.isEnabled = project.parts.count > 0 && PartsTable.selectedRow < project.parts.count
    }
    
    @objc func filamentsTableChanged() {
        removeFilamentButton.isEnabled = project.filaments.count > 0
        addPartButton.isEnabled = project.filaments.count > 0
        
        PartsTable.reloadData()
    }
}
