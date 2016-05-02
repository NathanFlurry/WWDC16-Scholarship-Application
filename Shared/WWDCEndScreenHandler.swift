//
//  WWDCEndScreenHandler.swift
//  WWDC16
//
//  Created by Nathan Flurry on 5/1/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCEndScreenHandler : WWDCEventHandler {
    var event: WWDCEvent? {
        didSet {
            if let event = event {
                // Hide the other text
                event.hideTextAndDate = true
                
                // Set event backwards forwards timeline
                event.positionOffset.z -= 25
                
                // Add the thank you
                let (applicantNode, _) = event.addText(
                    "Thank you for considering my application.",
                    fontName: "SourceSansPro-Bold",
                    size: 80,
                    position: SCNVector3(0, 0, 0),
                    alignment: kCAAlignmentCenter
                )
                applicantNode?.center()
            }
        }
    }
    
    init() {
        
    }
    
    func transitionIn(delay: NSTimeInterval, duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        
    }
    
    func transitionOut(duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        
    }
    
    func nextAndComplete() -> Bool {
        return true
    }
}