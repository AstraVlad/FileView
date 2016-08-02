//
//  PanelViewController.swift
//  FileView
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa

class PanelViewController: NSViewController{
    
    @IBOutlet weak var leftPanelOutlet: NSTableView!
    
    @IBOutlet weak var rightPanelOutlet: NSTableView!
    
    var leftPanelDir: DirectoryLoader!
    var rightPanelDir: DirectoryLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftPanelDir = DirectoryLoader(dirToLoad: "/users/vladimirfeldman/Documents")
        rightPanelDir = DirectoryLoader(dirToLoad: "/users/vladimirfeldman/Documents")
       
        if leftPanelOutlet != nil {
          leftPanelOutlet.setDelegate(self)
          leftPanelOutlet.setDataSource(self)
        }
        
        if rightPanelOutlet != nil {
          rightPanelOutlet.setDelegate(self)
          rightPanelOutlet.setDataSource(self)
          rightPanelOutlet.target = self
          rightPanelOutlet.doubleAction = #selector(PanelViewController.rightTableViewDoubleClick(_:))
        }
        
        
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func rightTableViewDoubleClick(sender: AnyObject) {
        
        anyTableViewDoubleClick(rightPanelOutlet, rightPanelDir)
        
        }
    
    func anyTableViewDoubleClick(theTableView: NSTableView, _ dir: DirectoryLoader){
        
        let item: fileDetails!
        
        if (theTableView.selectedRow >= 0) && (theTableView.selectedRow < dir.dirContents.count) {
            item = dir.dirContents[theTableView.selectedRow]
        } else {
            return
        }
        
        if item.isFolder {
            
            dir.currentDir = item.path
            theTableView.reloadData()
            
        } else {
            
            NSWorkspace.sharedWorkspace().openURL(NSURL(fileURLWithPath: item.path))
        }

    }

}

extension PanelViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if tableView.identifier == "leftTableID"{
            return (leftPanelDir.dirContents.count)
        } else if tableView.identifier == "rightTableID" {
            return (rightPanelDir.dirContents.count-1)
        } else {
            return 0
        }
        
    }
}

extension PanelViewController : NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        //var image:NSImage?
        var text:String = ""
        var cellIdentifier: String = ""
        let curDirLoader = tableView.identifier == "leftTableID" ? leftPanelDir : rightPanelDir
        let item: fileDetails!
        
        // 1
        if row < curDirLoader.dirContents.count {
            item = curDirLoader.dirContents[row]
        }else {
            return nil
        }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
           // image = item.icon
            text = item.name
            cellIdentifier = "nameCellID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.lastChange.description
            cellIdentifier = "dateCellID"
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.isFolder ? "--" : String(item.size)
            cellIdentifier = "sizeCellID"
        }
        
        // 3
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
 //           cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
}