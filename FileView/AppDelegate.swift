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
    
    private var panelViews: [NSView] = []
    
    private func addPanelView(panelView: NSView) {
        (panelView as! OnePanelView).setID(panelViews.count)
        panelViews.append(panelView)
    }
    
    private func findPanelViews(theView: NSView){
        if theView.subviews.count == 0 {return}
        for currentView in theView.subviews{
            if currentView is OnePanelView {addPanelView(currentView)}
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
        findPanelViews(NSApp.windows[0].contentView!)
        selectResponder()
        setSelectionForTables()

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        
    }


}

