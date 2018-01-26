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
    let statusItem = NSStatusBar.system.statusItem(withLength: -2.0)
    let sleepController = SleepController()
    
    // MARK: - Localized Strings
    
    private let preventSystemSleepTitle =
        NSLocalizedString("Prevent System Sleep",
                          comment: "Menu item title used to prevent system from activating sleep")
    private let allowSystemSleepTitle =
        NSLocalizedString("Allow System Sleep",
                          comment: "Menu item title used to allow system to activate sleep")
    
    // MARK: - Outlets
    
    @IBOutlet weak var siMenu: NSMenu!
    @IBOutlet weak var preventSleepMenuItem: NSMenuItem!
    
    // MARK: - Applicaiton Life Cycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: NSImage.Name(rawValue: "StatusItem")) {
                siButton.image = image
            }
        }
        siMenu.delegate = self
        statusItem.menu = siMenu
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: - NSMenuDelegate
    
    func menuWillOpen(_ menu: NSMenu) {
        updateIcon(imageName: "StatusItem")
    }
    
    func menuDidClose(_ menu: NSMenu) {
        switch sleepController.sleepState {
        case .allowSleep:
            updateIcon(imageName: "StatusItem")
        default:
            updateIcon(imageName: "StatusItemAlternate")
        }
    }
    
    private func updateIcon(imageName: String) {
        if let siButton = statusItem.button {
            if let image = NSImage(named: NSImage.Name(rawValue: imageName)) {
                siButton.image = image
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func preventSleepIndefinitely(_ sender: NSMenuItem) {
        var desiredState = SleepState.allowSleep
        
        // Toggle between .allowSleep and .preventSleepIndefinitely
        switch sleepController.sleepState {
        case .allowSleep:
            desiredState = .preventSleepIndefinitely
            preventSleepMenuItem.title = allowSystemSleepTitle
            updateIcon(imageName: "StatusItemAlternate")
        case .preventSleepIndefinitely:
            desiredState = .allowSleep
            preventSleepMenuItem.title = preventSystemSleepTitle
            updateIcon(imageName: "StatusItem")
        }
        
        sleepController.updateSleepState(to: desiredState)
    }
}
