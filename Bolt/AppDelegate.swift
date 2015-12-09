//
//  AppDelegate.swift
//  Bolt
//
//  Created by Robert Walker on 7/25/15.
//  Copyright (c) 2015 Robert Walker. All rights reserved.
//

import Cocoa
import IOKit.pwr_mgt

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2.0)
    var keepingAwake = false

    var assertionID1 : IOPMAssertionID = IOPMAssertionID(0)
    var assertionID2 : IOPMAssertionID = IOPMAssertionID(0)
    var success1: IOReturn?
    var success2: IOReturn?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: "StatusItem") {
                siButton.image = image
                siButton.target = self
                siButton.action = "handleClick"
            }
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func handleClick() {
        let imageName = (keepingAwake) ? "StatusItem" : "StatusItemAlternate"
        if let siButton = statusItem.button {
            if let image = NSImage(named: imageName) {
                siButton.image = image
                toggleKeepAwake();
            }
        }
    }
    
    func toggleKeepAwake() {
        let reasonForActivity = "Describe Activity Type" as CFString
        if (keepingAwake) {
            if success1 == kIOReturnSuccess {
                IOPMAssertionRelease(assertionID1)
            }
            if success2 == kIOReturnSuccess {
                IOPMAssertionRelease(assertionID2)
            }
        }
        else {
            success1 = IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleDisplaySleep, IOPMAssertionLevel(kIOPMAssertionLevelOn), reasonForActivity, &assertionID1)
            success2 = IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleSystemSleep, IOPMAssertionLevel(kIOPMAssertionLevelOn), reasonForActivity, &assertionID2)
        }
        keepingAwake = !keepingAwake
    }
}
