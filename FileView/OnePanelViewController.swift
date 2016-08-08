//
//  OnePanelViewController.swift
//  FileView
//
//  Created by Vladimir Feldman on 02.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa
import Quartz

class OnePanelViewController: NSViewController {
    
	@IBOutlet var onePanelView: NSView!
	
    @IBOutlet weak var tableOutlet: NSTableView!
	
	@IBOutlet weak var currentDirectoryLabel: NSTextFieldCell!
	
	@IBOutlet weak var selectedObjectLabel: NSTextFieldCell!
	
	private var nibObjects: NSArray? = nil
	
	private let formatter: NSNumberFormatter! = NSNumberFormatter()
	
    var dataSource: DirectoryLoader!
	
	var currentDirectory: String = "/Users/vladimirfeldman/Pictures/" {
        didSet {
            dataSource.currentDir = currentDirectory
            tableOutlet.reloadData()
        }
    }
	
	private let root: String = "/"
	
	private let upOneLevel: String = "..."
	
	private var previousCursorPositions: [Int] = []
	
	var fileTable: NSTableView {return tableOutlet != nil ? tableOutlet : nil}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        dataSource = DirectoryLoader(currentDirectory)
		NSBundle.mainBundle().loadNibNamed("OnePanelViewController", owner: self, topLevelObjects: &nibObjects)
		formatter.maximumFractionDigits = 1
		formatter.minimumFractionDigits = 0
		formatter.usesGroupingSeparator = true
	
        if tableOutlet != nil{
			tableOutlet.setDelegate(self)
			tableOutlet.setDataSource(self)
			tableOutlet.target = self
            tableOutlet.doubleAction = #selector(OnePanelViewController.tableViewDoubleClick(_:))
        }
		if (currentDirectoryLabel != nil) {currentDirectoryLabel.title = dataSource.currentDir}
		if (selectedObjectLabel != nil) {updateStatus()}
						
    }
	
	private func calculateTotalSize() -> Int {
		var size: Int = 0
		for rowIndex in tableOutlet.selectedRowIndexes{
			let item: fileDetails = dataSource.dirContents[rowIndex]
			if !item.isFolder {size += item.size}
		}
		return size
	}
	
	private func updateStatus(){
		
		let itemsSelected = tableOutlet.selectedRowIndexes.count
		
		if (itemsSelected == 0) {
			selectedObjectLabel.title = ""
		} else if (itemsSelected > 1 ) {
			selectedObjectLabel.title = "\(itemsSelected) objects selected, total size \(formatter.stringFromNumber(calculateTotalSize()/1000)!) kB"
			
		} else {
			selectedObjectLabel.title = dataSource.dirContents[tableOutlet.selectedRow].name
		}
		
	}
	
	
	func tableViewDoubleClick(sender: AnyObject) {
		
		processElement()
		
	}
	
	private func selectFile(position: Int?){
		
		let filePosition: Int!
		//print(position)
		
		if position != nil{
			filePosition = position!
		} else {
			filePosition = dataSource.dirContents.count > 2 ? 2 : 0
		}
		//print(filePosition)
		//if currentDirectory != root {
		(self.view as! OnePanelView).selectFileAtPosition(filePosition)
		//} else {
		//	(self.view as! OnePanelView).selectFileAtPosition(0)
		//}
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
			
			if (item.name  != root) && (item.name != upOneLevel) {
				previousCursorPositions.append(tableOutlet.selectedRow)
			}
			currentDirectory = item.path
			/*dataSource.currentDir = item.path
			tableOutlet.reloadData()*/
			currentDirectoryLabel.title = dataSource.currentDir
			
			if (item.name == upOneLevel) {
				selectFile(previousCursorPositions.popLast())
			} else if (item.name == root) {
				previousCursorPositions.removeAll()
				selectFile(0)
			} else {
				selectFile(nil)
			}
			
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
	
	private func doQuickLook(){
		if let panel = QLPreviewPanel.sharedPreviewPanel() {
			
			

			panel.makeKeyAndOrderFront(self)
		}
		
	}
	
	override func keyDown(theEvent: NSEvent){
		let charset = NSCharacterSet.alphanumericCharacterSet()
		//print(charset.characterIsMember(theEvent.keyCode))
		if theEvent.characters?.rangeOfCharacterFromSet(charset.invertedSet) == nil {
			//Let move focus to the text field
		}
		
		let chars = theEvent.characters?.unicodeScalars
		let char = chars![(chars?.startIndex)!].value
		
		switch Int(char) {
		case NSF3FunctionKey:
			doQuickLook()			
		default:
			interpretKeyEvents([theEvent])
		}
		
		
		
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
		
		var image:NSImage?
		var text:String = ""
		var cellIdentifier: String = ""
		let item: fileDetails!
		
		// 1
		if row < dataSource.dirContents.count {
			item = dataSource.dirContents[row]
		}else {
			return nil
		}
		
		// 2
		if tableColumn == tableOutlet.tableColumns[0] {
			image = item.icon
			text = item.name
			cellIdentifier = "nameCellID"
		} else if tableColumn == tableOutlet.tableColumns[1] {
			text = item.lastChange.description
			cellIdentifier = "dateCellID"
		} else if tableColumn == tableOutlet.tableColumns[2] {
			text = item.isFolder ? "--" : (formatter.stringFromNumber(item.size/1000)! + " kB")
			cellIdentifier = "sizeCellID"
		}
		
		// 3
		if let cell = tableOutlet.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
			cell.textField?.stringValue = text
			cell.imageView?.image = image ?? nil
			return cell
		}
		return nil
	}
	
	func tableViewSelectionDidChange(notification: NSNotification) {
		updateStatus()
	}
}


extension OnePanelViewController : QLPreviewPanelDelegate {
	
	override func acceptsPreviewPanelControl(panel: QLPreviewPanel!) -> Bool {
		return true
	}
	
	override func beginPreviewPanelControl(panel: QLPreviewPanel!) {
		panel.delegate = self
		panel.dataSource = self
	}
	
	override func endPreviewPanelControl(panel: QLPreviewPanel!) {
	}
}

extension OnePanelViewController : QLPreviewPanelDataSource {
	func numberOfPreviewItemsInPreviewPanel(panel: QLPreviewPanel!) -> Int {
		return tableOutlet.selectedRowIndexes.count
	}
	
	func previewPanel(panel: QLPreviewPanel!, previewItemAtIndex index: Int) -> QLPreviewItem! {
		let itemsSelected = tableOutlet.selectedRowIndexes.count
		if index < itemsSelected {
			return dataSource.dirContents[tableOutlet.selectedRowIndexes.sort()[index]].url
		}
		return nil
	}
	
}