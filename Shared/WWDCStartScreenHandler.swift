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
                
                // Move event down
                event.positionOffset.y -= 3
                
                // Set event backwards off timeline
                event.positionOffset.z += 25
                
                // Add instructions
                let (instructionsNode, _) = event.addText(
                    "Press the ← and → keys to navigate",
                    fontName: "SourceSansPro-Light",
                    size: 60,
                    position: SCNVector3(0, event.absoluteSize.height / 2 - 50, 0)
                )
                instructionsNode?.opacity = 0.5
                instructionsNode?.center()
                
                // Add the applicant
                let (applicantNode, _) = event.addText(
                    "Applicant – Nathan Flurry",
                    fontName: "SourceSansPro-Regular",
                    size: 60,
                    position: SCNVector3(0, -175, 250),
                    alignment: kCAAlignmentCenter
                )
                applicantNode?.center()
                
                
                // Add the title
                titleNode.position = SCNVector3(0, -150, 0)
                titleNode.center()
//                titleNode.position = SCNVector3(0, -265, 0) // For angular spacing
                event.addChildNode(titleNode)
            }
        }
    }
    
    // WWDC Title
    let titleNode: SCNNode
    let titleFont = "Menlo-Bold"
    let titleFontSize = 300 as CGFloat // Automatically scaled by slide
    let titleExtrusionDepth = 120 as CGFloat
    let titleChamfer = 10 as CGFloat
    var letterSpacing: CGFloat {
        return titleFontSize * 0.8
    }
    
    init() {
        // Get the string for the word
        let str = "WWDC16"
        
        // Get the colors for each individual letter
        let letterColors = [
            WWDCColors.pistachio, WWDCColors.redViolet, WWDCColors.whiskey, WWDCColors.jasper, // Leters
            WWDCColors.seaGreen, WWDCColors.seaGreen // Numbers
        ]
        
        // Create the title
        titleNode = SCNNode()
        
        // Create the letters
//        let angleRange = CGFloat.pi * 0.4 // For angular layout
//        let circleSize = 1000 as CGFloat
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
            
//            let angle = (CGFloat(i) / CGFloat(str.characters.count - 1)) * angleRange - angleRange / 2 // For angular spacing
//            let positionAngle = angle - CGFloat.pi / 2
//            charNode.position = SCNVector3(cos(positionAngle) * circleSize, 0, sin(positionAngle) * circleSize + circleSize)
//            charNode.eulerAngles.y = -angle
            
            
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