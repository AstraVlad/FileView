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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}