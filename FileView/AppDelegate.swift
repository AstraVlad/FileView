//
//  AppDelegate.swift
//  FileView
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var fileTables: [NSTableView] = []
    
    var currentTable: Int = 0
    
    func addFileTable(table: NSTableView){
        fileTables.append(table)
        Swift.print("In AppDelegate there are \(fileTables.count) tables found")
    }
    
    private func findTables(theView: NSView){
        if theView.subviews.count == 0 {return}
        for currentView in theView.subviews{
            if currentView.className == "NSTableView" {addFileTable(currentView as! NSTableView)}
            findTables(currentView)
        }
    }

    func selectResponder(){
        // let (view as! SplitView).sayWindow()
        let theWindow: NSWindow = NSApp.windows[0]
        if theWindow.makeFirstResponder(fileTables[currentTable]) {print("Table number \(currentTable) -- \(fileTables[currentTable]) selected in AppDelegate")}
    }
    
    private func setSelectionForTables(){
        fileTables[0].selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
        fileTables[1].selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        findTables(NSApp.windows[0].contentView!)
        NSApp.windows[0].initialFirstResponder = fileTables[currentTable]
        selectResponder()
        setSelectionForTables()

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

