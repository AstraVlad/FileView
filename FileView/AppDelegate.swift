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
    
    private var panelViews: [NSView] = []
    
    func addFileTable(table: NSTableView){
        fileTables.append(table)
    }
    
    private func addPanelView(panelView: NSView) {
        panelViews.append(panelView)
    }
    
    private func findTables(theView: NSView){
        if theView.subviews.count == 0 {return}
        for currentView in theView.subviews{
            if currentView.className == "NSTableView" {addFileTable(currentView as! NSTableView)}
            findTables(currentView)
        }
    }
    
    private func findPanelViews(theView: NSView){
        if theView.subviews.count == 0 {return}
        for currentView in theView.subviews{
           // print(currentView.className)
            if currentView.className == "FileView.OnePanelView" {addPanelView(currentView)}
            findPanelViews(currentView)
        }
    }

    func selectResponder(){
        let theView = panelViews[currentTable] as! OnePanelView
        theView.getFocus()
    }
    
    private func setSelectionForTables(){
        (panelViews[0] as! OnePanelView).selectFileAtPosition(0)
        (panelViews[1] as! OnePanelView).selectFileAtPosition(0)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        NSApp.windows[0].title = "FileView"
        findTables(NSApp.windows[0].contentView!)
        findPanelViews(NSApp.windows[0].contentView!)
        NSApp.windows[0].initialFirstResponder = fileTables[currentTable]
        selectResponder()
        setSelectionForTables()

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        
    }


}

