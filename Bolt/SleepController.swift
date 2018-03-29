//
//  SleepController.swift
//  Bolt
//
//  Created by Robert Walker on 7/6/17.
//  Copyright © 2017 Robert Walker. All rights reserved.
//

import Cocoa
import IOKit.pwr_mgt

enum SleepState {
    case allowSleep
    case preventSleepIndefinitely
}

fileprivate struct SleepModel {
    var assertionID: IOPMAssertionID = IOPMAssertionID(0)
    var success: IOReturn?
}

class SleepController {
    var sleepState = SleepState.allowSleep
    private var displaySleep = SleepModel()
    private var systemSleep = SleepModel()
    
    func allowSleep() {
        func allowDisplaySleep() {
            if displaySleep.success == kIOReturnSuccess {
                IOPMAssertionRelease(displaySleep.assertionID)
            }
        }
        
        func allowSystemSleep() {
            if systemSleep.success == kIOReturnSuccess {
                IOPMAssertionRelease(systemSleep.assertionID)
            }
        }
        
        allowDisplaySleep()
        allowSystemSleep()
        sleepState = .allowSleep
    }
    
    func preventSleep() {
        let reasonForActivity = "Bolt Controls System Sleep" as CFString
        
        func preventDisplaySleep() {
            displaySleep.success =
                IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString?,
                                            IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                            reasonForActivity, &displaySleep.assertionID)
        }
        
        func preventSystemSleep() {
            systemSleep.success =
                IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleSystemSleep as CFString?,
                                            IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                            reasonForActivity, &systemSleep.assertionID)
        }
        
        preventDisplaySleep()
        preventSystemSleep()
        sleepState = .preventSleepIndefinitely
    }
}
