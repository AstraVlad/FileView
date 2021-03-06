//
//  FileViewTests.swift
//  FileViewTests
//
//  Created by Vladimir Feldman on 01.08.16.
//  Copyright © 2016 Vladimir Feldman. All rights reserved.
//

import XCTest
@testable import FileView

class FileViewTests: XCTestCase {
    
    var dirloader: DirectoryLoader? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDirLoader() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        dirloader = DirectoryLoader(dirToLoad: "/")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.dirloader = DirectoryLoader(dirToLoad: "/")
        }
    }
    
}
