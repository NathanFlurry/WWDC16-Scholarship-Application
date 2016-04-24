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
        // Create a new scene
        mainScene = WWDCMainScene(sceneView: self)
        
        // Allows the user to manipulate the camera
        allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        showsStatistics = true
        
        // Configure the view
        backgroundColor = WWDCColor.blackColor()
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