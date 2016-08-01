//
//  directoryLoader.swift
//  FileView
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import Foundation

class DirectoryLoader {
    
    let rootDir = "/"
    var dirContents: [fileDetails]?
    var dirContentsString: [String] = []
    
    init (dirToLoad: String) {
        
        loadDir(dirToLoad)
    }
    
    func loadDir(dirToLoad: String) {
        
        var returnedDir: [NSURL]?
        
        let theURL: NSURL = NSURL.init(fileURLWithPath: dirToLoad, isDirectory: true)
        
        do {
            
            returnedDir = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(theURL, includingPropertiesForKeys: [], options: [])
        } catch {
            loadDir(rootDir)
        }
        
        
        for theURL in returnedDir!{
            do {
                let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(theURL.path!) as NSDictionary
                dirContents?.append(fileDetails(name: theURL.lastPathComponent!, icon: "", size: attributes["NSFileSize"]! as! Int, lastChange: attributes["NSFileModificationDate"] as! NSDate, permissions: attributes["NSFilePosixPermissions"]! as! Int))
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
         
        }
        
       
    }
    
}

struct fileDetails{
    var name: String
    var icon: String
    var size: Int
    var lastChange: NSDate
    var permissions: Int
}