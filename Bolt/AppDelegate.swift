//
//  AppDelegate.swift
//  Bolt
//
//  Created by Robert Walker on 7/25/15.
//  Copyright (c) 2015 Robert Walker. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    let statusItem = NSStatusBar.system().statusItem(withLength: -2.0)
    let sleepManager = SleepManager()

    @IBOutlet weak var siMenu: NSMenu!
    @IBOutlet weak var preventSleepMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: "StatusItem") {
                siButton.image = image
            }
        }
        siMenu.delegate = self
        statusItem.menu = siMenu
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func updateIcon(imageName: String) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: imageName) {
                siButton.image = image
            }
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        updateIcon(imageName: "StatusItem")
    }

    func menuDidClose(_ menu: NSMenu) {
        let imageName = (sleepManager.sleepState == .preventSleep) ? "StatusItem" : "StatusItemAlternate"
        updateIcon(imageName: imageName)
    }

    @IBAction func preventSleepIndefinitely(_ sender: NSMenuItem) {
        sleepManager.togglePreventSleep()
        let title = sleepManager.sleepState == .preventSleep
            ? NSLocalizedString("Allow System Sleep", comment: "Allow System to Sleep")
            : NSLocalizedString("Prevent System Sleep", comment: "Prevent System from Sleeping")
        preventSleepMenuItem.title = title
    }
}
