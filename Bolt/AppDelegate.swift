//
//  AppDelegate.swift
//  Bolt
//
//  Created by Robert Walker on 7/25/15.
//  Copyright (c) 2015 Robert Walker. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system().statusItem(withLength: -2.0)
    let sleepManager = SleepManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: "StatusItem") {
                siButton.image = image
                siButton.target = self
                siButton.action = #selector(AppDelegate.handleClick)
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func handleClick() {
        let imageName = (sleepManager.sleepState == .preventSleep) ? "StatusItem" : "StatusItemAlternate"
        if let siButton = statusItem.button {
            if let image = NSImage(named: imageName) {
                siButton.image = image
                sleepManager.togglePreventSleep()
            }
        }
    }
}
