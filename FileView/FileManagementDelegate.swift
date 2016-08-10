//
//  FileManagementDelegate.swift
//  FileView
//
//  Created by Vladimir Feldman on 09.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Foundation
import Cocoa

protocol FileManagementDelegate {
    func copyNow(fileUrl: NSURL, controller: FilePanelController) -> Bool
    func moveNow(fileUrl: NSURL, controller: FilePanelController) -> Bool
    func deleteNow(fileUrl: NSURL, controller: FilePanelController) -> Bool
    func setMeAsActivePanel(controller: FilePanelController) -> Bool
    func markMeAsActivePanel(controller: FilePanelController) -> Bool
}
