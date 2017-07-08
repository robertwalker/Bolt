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

struct SleepModel {
    var assertionID: IOPMAssertionID = IOPMAssertionID(0)
    var success: IOReturn?
}

class SleepController {
    var sleepState = SleepState.allowSleep
    private var displaySleep = SleepModel()
    private var systemSleep = SleepModel()

    func updateSleepState(state newState: SleepState) {
        let reasonForActivity = "Bolt Controls System Sleep" as CFString
        
        switch sleepState {
        case .allowSleep:
            // Prevent display sleep
            displaySleep.success =
                IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString!,
                                            IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                            reasonForActivity, &displaySleep.assertionID)
            
            // Prevent system sleep
            systemSleep.success =
                IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleSystemSleep as CFString!,
                                            IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                            reasonForActivity, &systemSleep.assertionID)
            
            // Update current state
            sleepState = newState
        case .preventSleepIndefinitely:
            if displaySleep.success == kIOReturnSuccess {
                IOPMAssertionRelease(displaySleep.assertionID)
            }
            if systemSleep.success == kIOReturnSuccess {
                IOPMAssertionRelease(systemSleep.assertionID)
            }
            sleepState = newState
        }
    }
}
