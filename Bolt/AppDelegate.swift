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
    let sleepController = SleepController()

    @IBOutlet weak var siMenu: NSMenu!
    @IBOutlet weak var preventSleepMenuItem: NSMenuItem!
    
    // MARK: - Applicaiton life cycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: "StatusItem") {
                siButton.image = image
            }
        }
        siMenu.delegate = self
        statusItem.menu = siMenu
        
        print(statusItem.behavior)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - NSMenuDelegate conformance

    func menuWillOpen(_ menu: NSMenu) {
        updateIcon(imageName: "StatusItem")
    }

    func menuDidClose(_ menu: NSMenu) {
        var imageName = "StatusItem"
        
        // The menu closes before the target's action is fired,
        // so if we're about to switch away from .allowSleep then we want the alternate icon image
        switch sleepController.sleepState {
        case .allowSleep:
            imageName = "StatusItemAlternate"
        case .preventSleepIndefinitely:
            imageName = "StatusItem"
        }
        updateIcon(imageName: imageName)
    }

    private func updateIcon(imageName: String) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: imageName) {
                siButton.image = image
            }
        }
    }
    
    // MARK: - StatusItem action

    @IBAction func preventSleepIndefinitely(_ sender: NSMenuItem) {
        let preventSystemSleepTitle =
            NSLocalizedString("Prevent System Sleep",
                              comment: "Menu item title used to prevent system from activating sleep")
        let allowSystemSleepTitle =
            NSLocalizedString("Allow System Sleep",
                              comment: "Menu item title used to allow system to activate sleep")
        var desiredState = SleepState.allowSleep
        
        // Toggle between .allowSleep and .preventSleepIndefinitely
        switch sleepController.sleepState {
        case .allowSleep:
            desiredState = .preventSleepIndefinitely
            preventSleepMenuItem.title = allowSystemSleepTitle
        case .preventSleepIndefinitely:
            desiredState = .allowSleep
            preventSleepMenuItem.title = preventSystemSleepTitle
        }
        
        sleepController.updateSleepState(state: desiredState)
    }
}
