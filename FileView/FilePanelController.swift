//
//  FileDataSource.swift
//  FileView
//
//  Created by Vladimir Feldman on 10.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Foundation

protocol FilePanelController: class {
    var delegate: FileManagementDelegate? {get set}
    var ID: Int? {get set}
    var currentDirectory: String {get set}
    func getSelectedFiles() -> [NSURL]
    func getFocus() -> Bool
    func gotFocus()
    func refresh()
}