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

   // var fileTables: [NSTableView] = []
    
    var currentTable: Int = 0
    
    private var panelViews = [Int: OnePanelView]()
    
    private func addPanelView(panelView: NSView) {
        //(panelView as! OnePanelView).setID(panelViews.count)
        panelViews[(panelView as! OnePanelView).getID()!] = (panelView as! OnePanelView)
    }
    
    private func findPanelViews(theView: NSView){
        if theView.subviews.count == 0 {return}
        for currentView in theView.subviews{
            if currentView is OnePanelView {addPanelView(currentView)}
            findPanelViews(currentView)
        }
    }

    func selectResponder(){
        panelViews[currentTable]?.getFocus()
    }
    
    private func setSelectionForTables(){
        panelViews[0]?.selectFileAtPosition(0)
        panelViews[1]?.selectFileAtPosition(0)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        NSApp.windows[0].title = "FileView"
        findPanelViews(NSApp.windows[0].contentView!)
        selectResponder()
        setSelectionForTables()

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        
    }


}

