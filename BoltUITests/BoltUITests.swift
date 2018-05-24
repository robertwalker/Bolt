//
//  BoltUITests.swift
//  BoltUITests
//
//  Created by Robert Walker on 2/1/18.
//  Copyright © 2018 Robert Walker. All rights reserved.
//

import XCTest
@testable import Bolt

class BoltUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testToggleSleepIndefinitelyOnAndOff() {
        let app = XCUIApplication()
        let statusItemElement = app.statusItems.firstMatch
        let menuItemElement = statusItemElement.menus.menuItems.firstMatch
        
        for _ in 0..<2 {
            XCTAssertTrue(statusItemElement.exists)
            statusItemElement.click()
            XCTAssertTrue(menuItemElement.exists)
            menuItemElement.click()
            sleep(1)
        }
    }
}
