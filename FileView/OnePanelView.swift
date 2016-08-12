//
//  OnePanelView.swift
//  FileView
//
//  Created by Vladimir Feldman on 02.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa

class OnePanelView: NSView {
    
    let tableViewTag = 1
    
    private var ID: Int?
        
    func getFocus(){
        self.window?.makeFirstResponder(self.viewWithTag(tableViewTag))
    
    }
    
    func setID (newID: Int){
        if ID != nil {
            return
        } else {
            ID = newID
        }
    }
    
    func getID() -> Int? {
        return ID
    }
    
    func selectFileAtPosition(position: Int) -> Bool {
        
        let fileTable = self.viewWithTag(tableViewTag) as! NSTableView
        if position < fileTable.numberOfRows {
         fileTable.selectRowIndexes(NSIndexSet(index: position), byExtendingSelection: false)
         return true
        }
        fileTable.selectRowIndexes(NSIndexSet(index: fileTable.numberOfRows-1), byExtendingSelection: false)
        return false
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    
    
}
