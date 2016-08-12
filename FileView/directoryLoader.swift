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
    var icon: NSImage?
    var size: Int
    var lastChange: NSDate
    var permissions: Int
    var isFolder: Bool
    var url: NSURL
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
    
    func reload(){
        loadDir(currentDir)
    }
    

    private func loadDir(dirToLoad: String) {
        
        var returnedDir: [NSURL]?
        var isFolder = false
        var theImage: NSImage?
        
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
                
                //If file name starts with dot (.) or $ then do not show that file
                let lastPartOfThePath = theURL.pathComponents![(theURL.pathComponents?.count)!-1]
                if (lastPartOfThePath[lastPartOfThePath.startIndex] == ".") || (lastPartOfThePath[lastPartOfThePath.startIndex] == "$") {continue}
                
                let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(theURL.path!) as NSDictionary
                //let properties = try theURL.resourceValuesForKeys(requiredAttributes)
                
                let realPath: String!
                
                switch (attributes[NSFileType] as! String) {
                case NSFileTypeDirectory:
                    isFolder = true
                    theImage = NSImage(named:  NSImageNameFolder)
                    realPath = theURL.path!
                case NSFileTypeSymbolicLink:
                    
                    theImage = NSImage(named: NSImageNameShareTemplate)
                    try realPath = "/" +  NSFileManager.defaultManager().destinationOfSymbolicLinkAtPath(theURL.path!)
                    let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(realPath) as NSDictionary
                    if (attributes[NSFileType] as! String) == NSFileTypeDirectory {
                        isFolder =  true
                    } else {
                        isFolder =  false
                    }
                default:
                    isFolder = false
                    theImage = NSWorkspace.sharedWorkspace().iconForFileType(theURL.pathExtension!)
                    realPath = theURL.path!                    
                }
                
                
                let file = fileDetails(path: realPath, name: theURL.lastPathComponent!, icon: theImage, size: attributes[NSFileSize]! as! Int, lastChange: attributes[NSFileModificationDate] as! NSDate, permissions: attributes[NSFilePosixPermissions]! as! Int, isFolder: isFolder, url: theURL)
                
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
        dirContents.append(fileDetails(path: "/", name: "/", icon: nil, size: 0, lastChange: NSDate(), permissions: 0, isFolder: true, url: NSURL(string: "/")!))
        var upDir = ""
        for index in 0..<(url.pathComponents!.count-1) {
            if index > 1 {upDir.appendContentsOf("/")}
            upDir.appendContentsOf(url.pathComponents![index])        
        }
        dirContents.append(fileDetails(path: upDir, name: "...", icon: nil, size: 0, lastChange: NSDate(), permissions: 0, isFolder: true, url: NSURL(string: upDir)!))
        
    }
    
}

