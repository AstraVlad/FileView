//
//  FileDataSource.swift
//  FileView
//
//  Created by Vladimir Feldman on 10.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Foundation

protocol FilePanelController {
    func getSelectedFiles() -> [NSURL]
    func getFocus() -> Bool
    func gotFocus()
    var ID: Int? {get}
}