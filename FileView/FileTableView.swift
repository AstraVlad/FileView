//
//  FileTableView.swift
//  FileView
//
//  Created by Vladimir Feldman on 10.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa

class FileTableView: NSTableView {
    
    var fileDelegate: FilePanelController?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func becomeFirstResponder() -> Bool {
        fileDelegate?.gotFocus()
        return true
    }
    
}
