//
//  StatusItemController.swift
//  Bolt
//
//  Created by Robert Walker on 1/26/18.
//  Copyright © 2018 Robert Walker. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let sleepController = SleepController()
    
    // MARK: - Localized Strings
    
    private let preventSystemSleepTitle =
        NSLocalizedString("Prevent System Sleep",
                          comment: "Menu item title used to prevent system from activating sleep")
    private let allowSystemSleepTitle =
        NSLocalizedString("Allow System Sleep",
                          comment: "Menu item title used to allow system to activate sleep")
    
    // MARK: - Private functions
    
    private func updateIcon(imageName: String) {
        if let siButton = statusItem.button, let image = NSImage(named: imageName) {
            siButton.image = image
        }
    }
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        let siButton = statusItem.button!
        if let image = NSImage(named: "StatusItem") {
            siButton.image = image
        }
        
        siMenu.delegate = self
        statusItem.menu = siMenu
    }
    
    // MARK: - Outlets
    
    @IBOutlet var siMenu: NSMenu!
    @IBOutlet var preventSleepMenuItem: NSMenuItem!
    
    // MARK: - Actions
    
    @IBAction func preventSleepIndefinitely(_ sender: NSMenuItem) {
        switch sleepController.sleepState {
        case .allowSleep:
            preventSleepMenuItem.title = allowSystemSleepTitle
            updateIcon(imageName: "StatusItemAlternate")
            sleepController.preventSleep()
        default:
            preventSleepMenuItem.title = preventSystemSleepTitle
            updateIcon(imageName: "StatusItem")
            sleepController.allowSleep()
        }
    }
}

// MARK: - NSMenuDelegate

extension StatusItemController: NSMenuDelegate {
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
}
