//
//  SleepControllerTests.swift
//  BoltTests
//
//  Created by Robert Walker on 1/26/18.
//  Copyright © 2018 Robert Walker. All rights reserved.
//

import Cocoa
import XCTest
@testable import Bolt

class SleepControllerTests: XCTestCase {
    func testKeepAwake() {
        let sleepController = SleepController()
        sleepController.updateSleepState(to: .preventSleepIndefinitely)
        XCTAssertEqual(sleepController.sleepState, .preventSleepIndefinitely)
    }
    
    func testAllowSleep() {
        let sleepController = SleepController()
        sleepController.updateSleepState(to: .allowSleep)
        XCTAssertEqual(sleepController.sleepState, .allowSleep)
    }
    
    func testPerformanceKeepAwake() {
        self.measure() {
            let sleepController = SleepController()
            sleepController.updateSleepState(to: .preventSleepIndefinitely)
            XCTAssertEqual(sleepController.sleepState, .preventSleepIndefinitely)
            sleepController.updateSleepState(to: .allowSleep)
            XCTAssertEqual(sleepController.sleepState, .allowSleep)
        }
    }
}
