//
//  WWDCGameView.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCGameView : SCNView {
    static var singleton : WWDCGameView!
    
    let printFonts = false
    
    var mainScene: WWDCMainScene? {
        get {
            return scene as? WWDCMainScene
        }
        set {
            scene = newValue
        }
    }
    
    #if os(iOS) || os(tvOS)
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        appeared()
    }
    #elseif os(OSX)
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        setup()
    }
    
    override func setFrameSize(newSize: NSSize) {
        super.setFrameSize(newSize)
        appeared()
    }
    #endif
    
    private func setup() {
        // DEBUG: Print out all the fonts
        if printFonts {
            #if os(iOS)
            _ = UIFont.familyNames().map {
                print("\($0): \(UIFont.fontNamesForFamilyName($0))")
            }
            #elseif os(OSX)
            _ = AppKit.NSFontManager.sharedFontManager().availableFontFamilies.map {
                Swift.print("\($0): \(NSFontManager.sharedFontManager().availableMembersOfFontFamily($0)!)")
            }
            #endif
        }
        
        // Create a new scene
        mainScene = WWDCMainScene(sceneView: self)
        
        // Allows the user to manipulate the camera
//        allowsCameraControl = true
        
        // Show statistics such as fps and timing information
//        showsStatistics = true
        
        // Enable jittering
        jitteringEnabled = true
        
        // Configure the view
        backgroundColor = mainScene!.bgColor
    }
    
    private func appeared() {
        // Do layout and stuff here
    }
    
    @IBAction func nextSlide(sender: AnyObject) {
        mainScene?.nextSlide()
    }
    
    @IBAction func previousSlide(sender: AnyObject) {
        mainScene?.previousSlide()
    }
}