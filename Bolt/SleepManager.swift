//
//  SleepManager.swift
//  Bolt
//
//  Created by Robert Walker on 7/6/17.
//  Copyright © 2017 Robert Walker. All rights reserved.
//

import Cocoa
import IOKit.pwr_mgt

enum SleepState {
    case allowSleep
    case preventSleep
}

struct StateModel {
    var assertionID1: IOPMAssertionID = IOPMAssertionID(0)
    var assertionID2: IOPMAssertionID = IOPMAssertionID(0)
    var success1: IOReturn?
    var success2: IOReturn?
}

class SleepManager {
    var sleepState = SleepState.allowSleep
    private var model = StateModel(assertionID1: IOPMAssertionID(0),
                                   assertionID2: IOPMAssertionID(0),
                                   success1: nil,
                                   success2: nil)

    func togglePreventSleep() {
        let reasonForActivity = "Bolt Controls System Sleep" as CFString
        
        switch sleepState {
        case .allowSleep:
            model.success1 = IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString!,
                                                         IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                         reasonForActivity, &model.assertionID1)
            model.success2 = IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleSystemSleep as CFString!,
                                                         IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                         reasonForActivity, &model.assertionID2)
            sleepState = .preventSleep
        case .preventSleep:
            if model.success1 == kIOReturnSuccess {
                IOPMAssertionRelease(model.assertionID1)
            }
            if model.success2 == kIOReturnSuccess {
                IOPMAssertionRelease(model.assertionID2)
            }
            sleepState = .allowSleep
        }
    }
}
