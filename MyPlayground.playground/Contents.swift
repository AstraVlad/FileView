//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

var i = 0
i = i^1
i = i^1

class Class {
    func testmethod1() { print("testmethod1") }
    final func testmethod2() { print("testmethod2") }
}

class Subclass: Class {
    override func testmethod1() { print("overridden testmethod1") }
}

func TestFunc(obj: Class) {
    obj.testmethod1()
    obj.testmethod2()
}

//TestFunc(Subclass())

var arr: [Class] = [Class(), Class()]
arr[1] = Class()

