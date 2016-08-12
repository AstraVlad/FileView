//
//  SplitViewController.swift
//  FileView
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa
//import Dispatch

class SplitViewController: NSSplitViewController {
    
    private let appDelegate = NSApp.delegate as! AppDelegate
    private var panelControllers: [FilePanelController] = []
    
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
            if controller is FilePanelController {
                let theController = (controller as! FilePanelController)
                theController.delegate = self
                theController.ID = panelControllers.count
                panelControllers.append(theController)
            }
        }
    }
        
    override func insertTab(sender: AnyObject?) {
        appDelegate.currentTable = appDelegate.currentTable^1
        appDelegate.selectResponder()
       
    }
    
}

extension SplitViewController : FileManagementDelegate {
    
    func copyNow(source: FilePanelController) -> Bool {
        let targetID = source.ID!^1
        let filesToDo = source.getSelectedFiles()
        for fileToProcess in filesToDo {
            let target = panelControllers[targetID].currentDirectory + "/" + fileToProcess.lastPathComponent!
            print(target)
            print(fileToProcess.path!)
            if target == fileToProcess.path! {
                let myPopup: NSAlert = NSAlert()
                myPopup.messageText = "Can not copy file \(fileToProcess.lastPathComponent!) into itself!"
                myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                myPopup.addButtonWithTitle("OK")
                myPopup.runModal()
                return false

            }
            do {
                try NSFileManager.defaultManager().copyItemAtPath(fileToProcess.path!, toPath: target)
            } catch NSCocoaError.FileWriteFileExistsError {
                let myPopup: NSAlert = NSAlert()
                myPopup.messageText = "File \(fileToProcess.lastPathComponent!) already exists in target directory, overwrite?"
                myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                myPopup.addButtonWithTitle("Yes")
                myPopup.addButtonWithTitle("No")
                myPopup.runModal()
                return false
            } catch {
                let myPopup: NSAlert = NSAlert()
                myPopup.messageText = "Error while copying file \(fileToProcess.lastPathComponent!)"
                myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                myPopup.addButtonWithTitle("OK")
                myPopup.runModal()
                return false
            }
        }
        panelControllers[targetID].refresh()
        return true
    }
    
    func moveNow(source: FilePanelController) -> Bool {
        let targetID = source.ID!^1
        let filesToDo = source.getSelectedFiles()
        for fileToProcess in filesToDo {
            let target = panelControllers[targetID].currentDirectory + "/" + fileToProcess.lastPathComponent!
            do {
                try NSFileManager.defaultManager().moveItemAtPath(fileToProcess.path!, toPath: target)
            } catch NSCocoaError.FileWriteFileExistsError {
                let myPopup: NSAlert = NSAlert()
                myPopup.messageText = "File \(fileToProcess.lastPathComponent!) already exists in target directory, overwrite?"
                myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                myPopup.addButtonWithTitle("Yes")
                myPopup.addButtonWithTitle("No")
                myPopup.runModal()
                return false
            } catch {
                let myPopup: NSAlert = NSAlert()
                myPopup.messageText = "Error while moving file \(fileToProcess.lastPathComponent!)"
                myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                myPopup.addButtonWithTitle("OK")
                myPopup.runModal()
                return false
            }

        }
        source.refresh()
        panelControllers[targetID].refresh()
        return true
    }

    func deleteNow(source: FilePanelController) -> Bool {
        let filesToDo = source.getSelectedFiles()
        for fileToProcess in filesToDo {
            do {
                try NSFileManager.defaultManager().trashItemAtURL(fileToProcess, resultingItemURL: nil)
            } catch {
                let myPopup: NSAlert = NSAlert()
                myPopup.messageText = "Error while trying to move file \(fileToProcess.lastPathComponent!) to the Trash Bin."
                myPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                myPopup.addButtonWithTitle("OK")
                myPopup.runModal()
                return false

            }
        }

        source.refresh()
        return true
    }
    
    func setMeAsActivePanel(source: FilePanelController) -> Bool {
        if source.ID != nil {
            appDelegate.currentTable = source.ID!
            appDelegate.selectResponder()
            return true
        } else {
            return false
        }
        
    }
    
    func markMeAsActivePanel(source: FilePanelController) -> Bool{
        if source.ID != nil {
            appDelegate.currentTable = source.ID!
            return true
        } else {
            return false
        }
    }
    
}
