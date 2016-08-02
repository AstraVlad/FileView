//
//  SplitViewController.swift
//  FileView
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
       splitView.setPosition(view.bounds.width / 2.0, ofDividerAtIndex: 0)
    }
    
  /*override func splitView(splitView: NSSplitView, constrainSplitPosition proposedPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return view.bounds.width / 2.0
  }*/
}
