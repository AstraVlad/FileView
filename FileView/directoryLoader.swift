//
//  directoryLoader.swift
//  FileView
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Foundation
import AppKit

struct fileDetails{
    var path: String
    var name: String
    var icon: String
    var size: Int
    var lastChange: NSDate
    var permissions: Int
    var isFolder: Bool
}

class DirectoryLoader {
    
    let rootDir = "/"
    var dirContents: [fileDetails] = []
    var dirContentsString: [String] = []
    var currentDir: String {
        didSet {
            loadDir(currentDir)
        }
    }
    
    init (_ dirToLoad: String) {
        
        currentDir = dirToLoad
        loadDir(currentDir)
        
    }
    

    func loadDir(dirToLoad: String) {
        
        var returnedDir: [NSURL]?
       // let requiredAttributes = [NSURLLocalizedNameKey, NSURLEffectiveIconKey,NSURLTypeIdentifierKey,NSURLCreationDateKey,NSURLFileSizeKey, NSURLIsDirectoryKey,NSURLIsPackageKey]
        
        let theURL: NSURL = NSURL.init(fileURLWithPath: dirToLoad, isDirectory: true)
        
        do {
            
            returnedDir = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(theURL, includingPropertiesForKeys: [], options: [])
        } catch {
            loadDir(rootDir)
        }
        
        prepareToLoad(theURL)
        
        for theURL in returnedDir!{
            do {
                let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(theURL.path!) as NSDictionary
                //let properties = try theURL.resourceValuesForKeys(requiredAttributes)
                let file = fileDetails(path: theURL.path!, name: theURL.lastPathComponent!, icon: "", size: attributes[NSFileSize]! as! Int, lastChange: attributes[NSFileModificationDate] as! NSDate, permissions: attributes[NSFilePosixPermissions]! as! Int, isFolder: (attributes[NSFileType] as! String) == NSFileTypeDirectory)
                dirContents.append(file)
                // dirContents?.append(fileDetails(name: properties[NSURLLocalizedNameKey] as! String, icon: properties[NSURLEffectiveIconKey] as! NSImage, size: properties[NSURLFileSizeKey] as! Int, lastChange: attributes[NSFileModificationDate] as! NSDate, permissions: attributes[NSFilePosixPermissions]! as! Int, isFolder: properties[NSURLIsDirectoryKey] as! Bool))
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
         
        }
        
       
    }
    
    private func prepareToLoad(url: NSURL){
        
        dirContents.removeAll()
        if url.path == "/" {return}
        dirContents.append(fileDetails(path: "/", name: "/", icon: "", size: 0, lastChange: NSDate(), permissions: 0, isFolder: true))
        var upDir = ""
        for index in 0..<(url.pathComponents!.count-1) {
            upDir.appendContentsOf(url.pathComponents![index])
            if index > 0 {upDir.appendContentsOf("/")}
        
        }
        dirContents.append(fileDetails(path: upDir, name: "...", icon: "", size: 0, lastChange: NSDate(), permissions: 0, isFolder: true))
        
    }
    
}

