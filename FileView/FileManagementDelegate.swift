//
//  FileManagementDelegate.swift
//  FileView
//
//  Created by Vladimir Feldman on 09.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Foundation
import Cocoa

protocol FileManagementDelegate: class {
    func copyNow(source: FilePanelController) -> Bool
    func moveNow(source: FilePanelController) -> Bool
    func deleteNow(source: FilePanelController) -> Bool
    func setMeAsActivePanel(source: FilePanelController) -> Bool
    func markMeAsActivePanel(source: FilePanelController) -> Bool
}
