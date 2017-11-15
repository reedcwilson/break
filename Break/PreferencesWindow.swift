//
//  PreferencesWindow.swift
//  Break
//
//  Created by Reed Wilson on 11/14/17.
//  Copyright © 2017 Reed Wilson. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {

    override var windowNibName: NSNib.Name? {
        return NSNib.Name(rawValue: "PreferencesWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
    }
}
