//
//  WWDCStartScreenHandler.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/25/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCStartScreenHandler : WWDCEventHandler {
    var event: WWDCEvent? {
        didSet {
            if let event = event {
                // Hide the other text
                event.hideTextAndDate = true
                
                // Add the node
                var v1 = SCNVector3()
                var v2 = SCNVector3()
                titleNode.getBoundingBoxMin(&v1, max: &v2)
                titleNode.position = titleNode.position - (v2 - v1) / 2
                event.addChildNode(titleNode)
            }
        }
    }
    
    // Title
    let titleNode: SCNNode
    let titleFont = "Menlo-Bold"
    let titleFontSize: CGFloat = 300 // Automatically scaled by slide
    let titleExtrusionDepth: CGFloat = 120
    let titleChamfer: CGFloat = 10
    var letterSpacing: CGFloat {
        return titleFontSize * 0.8
    }
    
    init() {
        // Get the string for the word
        let str = "WWDC16"
        
        // Get the colors for each individual letter
        let letterColors = [
            WWDCColors.seaGreen, WWDCColors.jasper, WWDCColors.whiskey, WWDCColors.redViolet, // Letters
            WWDCColors.pistachio, WWDCColors.pistachio // Numbers
        ]
        
        // Create the title
        titleNode = SCNNode()
        
        // Create the letters
        for (i, char) in str.characters.enumerate() {
            // Create the text
            let charText = SCNText()
            charText.string = "\(char)"
            charText.extrusionDepth = titleExtrusionDepth
            charText.chamferProfile = straightChamferProfile
            charText.chamferRadius = titleChamfer
            charText.font = WWDCFont(name: titleFont, size: titleFontSize)
            
            // Create the materials
            let colored = SCNMaterial()
            let plain = SCNMaterial()
            colored.diffuse.contents = letterColors[i]
            colored.emission.contents = letterColors[i].colorWithAlphaComponent(0.5)
            plain.diffuse.contents = WWDCColor.whiteColor()
            // (1) front (2) back (3) side (4) front chamfer (5) back chamfer
            charText.materials = [ colored, colored, plain, colored, colored ]
//            charText.materials = [ side, side, front, side, side ]
            
            // Create the node
            let charNode = SCNNode(geometry: charText)
            charNode.position = SCNVector3(CGFloat(i) * letterSpacing, 0, 0)
            titleNode.addChildNode(charNode)
        }
    }
    
    func transitionIn(delay: NSTimeInterval, duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        
    }
    
    func transitionOut(duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        
    }
    
    func nextAndComplete() -> Bool {
        return true
    }
}