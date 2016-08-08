//
//  SplitViewController.swift
//  FileView
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {
    
    let appDelegate = NSApp.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        splitView.setPosition(view.bounds.width / 2.0, ofDividerAtIndex: 0)
    }
    
    
  /*  override func keyDown(theEvent: NSEvent){
  
        interpretKeyEvents([theEvent])
        //let r: NSResponder!
        
    }*/
    
    override func insertTab(sender: AnyObject?) {
        
        switch appDelegate.currentTable {
        case 0:
            appDelegate.currentTable = 1
        default:
            appDelegate.currentTable = 0
        }
        appDelegate.selectResponder()
    }
    
    
  /*override func splitView(splitView: NSSplitView, constrainSplitPosition proposedPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return view.bounds.width / 2.0
  }*/
}
