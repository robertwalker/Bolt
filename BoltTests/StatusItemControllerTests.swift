//
//  StatusItemControllerTests.swift
//  BoltTests
//
//  Created by Robert Walker on 1/26/18.
//  Copyright © 2018 Robert Walker. All rights reserved.
//

import Cocoa
import XCTest
@testable import Bolt

class StatusItemControllerTests: XCTestCase {
    var controller: StatusItemController!
    var menuItemDouble: NSMenuItem!
    
    override func setUp() {
        super.setUp()
        menuItemDouble = NSMenuItem()
        menuItemDouble.title = "Test Double"
        controller = StatusItemController()
        controller.preventSleepMenuItem = menuItemDouble
    }

    func testPreventSleepIndefinitely() {
        controller.preventSleepIndefinitely(menuItemDouble)
        XCTAssertEqual(menuItemDouble.title, "Allow System Sleep")
    }
    
    func testPreventSleepIndefinitelyOnThenOff() {
        controller.preventSleepIndefinitely(menuItemDouble)
        XCTAssertEqual(menuItemDouble.title, "Allow System Sleep")
        controller.preventSleepIndefinitely(menuItemDouble)
        XCTAssertEqual(menuItemDouble.title, "Prevent System Sleep")
    }
}
