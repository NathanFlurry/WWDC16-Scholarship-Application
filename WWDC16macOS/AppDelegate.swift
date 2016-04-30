//
//  AppDelegate.swift
//  WWDC16macOS
//
//  Created by Nathan Flurry on 4/18/16.
//  Copyright (c) 2016 Nathan Flurry. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Make the window dark
        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        window.invalidateShadow()
    }
}
