//
//  OnePanelViewController.swift
//  FileView
//
//  Created by Vladimir Feldman on 02.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa

class OnePanelViewController: NSViewController {
    
	@IBOutlet var onePanelView: NSView!
	
    @IBOutlet weak var tableOutlet: NSTableView!
	
	@IBOutlet weak var currentDirectoryLabel: NSTextFieldCell!
	
	@IBOutlet weak var selectedObjectLabel: NSTextFieldCell!
	
	var nibObjects: NSArray? = nil
	
    var dataSource: DirectoryLoader!
	
	var currentDirectory: String = "/" {
        didSet {
            dataSource.currentDir = currentDirectory
            tableOutlet.reloadData()
        }
    }
	
	let root: String = "/"
	
	var fileTable: NSTableView {return tableOutlet != nil ? tableOutlet : nil}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        dataSource = DirectoryLoader(currentDirectory)
		NSBundle.mainBundle().loadNibNamed("OnePanelViewController", owner: self, topLevelObjects: &nibObjects)
		//(nibObjects as NSArray).
        if tableOutlet != nil{
			tableOutlet.setDelegate(self)
			tableOutlet.setDataSource(self)
			tableOutlet.target = self
            tableOutlet.doubleAction = #selector(OnePanelViewController.tableViewDoubleClick(_:))
        }
		if (currentDirectoryLabel != nil) {currentDirectoryLabel.title = dataSource.currentDir}
		if (selectedObjectLabel != nil) {updateStatus()}
						
    }
	
	func updateStatus(){
		
		let itemsSelected = tableOutlet.selectedRowIndexes.count
		
		if (itemsSelected == 0) {
			selectedObjectLabel.title = ""
		} else if (itemsSelected > 1 ) {
			selectedObjectLabel.title = "\(itemsSelected) objects selected"
		} else {
			selectedObjectLabel.title = dataSource.dirContents[tableOutlet.selectedRow].name
		}
		
	}
	
	func tableViewDoubleClick(sender: AnyObject) {
		
		processElement()
		
	}
	
	private func processElement(){
		
		if tableOutlet.selectedRowIndexes.count > 1 {return}
		
		let item: fileDetails!
		
		if (tableOutlet.selectedRow >= 0) && (tableOutlet.selectedRow < dataSource.dirContents.count) {
			item = dataSource.dirContents[tableOutlet.selectedRow]
		} else {
			return
		}
		
		if item.isFolder {
			
			dataSource.currentDir = item.path
			tableOutlet.reloadData()
			currentDirectoryLabel.title = dataSource.currentDir
			
			
		} else {
			
			NSWorkspace.sharedWorkspace().openURL(NSURL(fileURLWithPath: item.path))
		}
	}
	
	private func stepUp(){
		if dataSource.currentDir != root {
			tableOutlet.selectRowIndexes(NSIndexSet(index: 1), byExtendingSelection: false)
			processElement()
		}
	}
	
	override func keyDown(theEvent: NSEvent){
		
		interpretKeyEvents([theEvent])
		
		
	}
	
	override func insertNewline(sender: AnyObject?){
		
		processElement()
	}
	
	override func deleteBackward(sender: AnyObject?){
		stepUp()
	}
	
}

extension OnePanelViewController : NSTableViewDataSource {
	func numberOfRowsInTableView(tableOutlet: NSTableView) -> Int {
		
		return (dataSource.dirContents.count)
		
	}
}

extension OnePanelViewController : NSTableViewDelegate {
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		//var image:NSImage?
		var text:String = ""
		var cellIdentifier: String = ""
		//let curDirLoader = tableView.identifier == "leftTableID" ? leftPanelDir : rightPanelDir
		let item: fileDetails!
		
		// 1
		if row < dataSource.dirContents.count {
			item = dataSource.dirContents[row]
		}else {
			return nil
		}
		
		// 2
		if tableColumn == tableOutlet.tableColumns[0] {
			// image = item.icon
			text = item.name
			cellIdentifier = "nameCellID"
		} else if tableColumn == tableOutlet.tableColumns[1] {
			text = item.lastChange.description
			cellIdentifier = "dateCellID"
		} else if tableColumn == tableOutlet.tableColumns[2] {
			text = item.isFolder ? "--" : String(item.size)
			cellIdentifier = "sizeCellID"
		}
		
		// 3
		if let cell = tableOutlet.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
			cell.textField?.stringValue = text
			//           cell.imageView?.image = image ?? nil
			return cell
		}
		return nil
	}
	
	func tableViewSelectionDidChange(notification: NSNotification) {
		updateStatus()
	}
}