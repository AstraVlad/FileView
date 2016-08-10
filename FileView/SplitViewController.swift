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
        for controller in self.childViewControllers{
            if controller is OnePanelViewController{
                (controller as! OnePanelViewController).delegate = self
            }
        }
    }
        
    override func insertTab(sender: AnyObject?) {
        appDelegate.currentTable = appDelegate.currentTable^1
        appDelegate.selectResponder()
    }
    
}

extension SplitViewController : FileManagementDelegate {
    func copyNow(fileUrl: NSURL, controller: FilePanelController) -> Bool {
        print("Copy function launched for \(controller.getSelectedFiles().count) file(s)")
        return true
    }
    func moveNow(fileUrl: NSURL, controller: FilePanelController) -> Bool {
        print("Move function launched for \(controller.getSelectedFiles().count) file(s)")
        return true
    }

    func deleteNow(fileUrl: NSURL, controller: FilePanelController) -> Bool {
        return true
    }
    
    func setMeAsActivePanel(controller: FilePanelController) -> Bool {
        if controller.ID != nil {
            appDelegate.currentTable = controller.ID!
            appDelegate.selectResponder()
            return true
        } else {
            return false
        }
        
    }
    
    func markMeAsActivePanel(controller: FilePanelController) -> Bool{
        if controller.ID != nil {
            appDelegate.currentTable = controller.ID!
            return true
        } else {
            return false
        }
    }
    
}
