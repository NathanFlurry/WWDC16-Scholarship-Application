//
//  WWDCCamera.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCCamera : SCNNode {
    // Distance the camera stays from each slide
    let cameraDistance: CGFloat = 10
    
    override init() {
        super.init()
        
        camera = SCNCamera()
        camera?.automaticallyAdjustsZRange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transitionToEvent(event: WWDCEvent, animated: Bool = true) {
        // Remove any previous actions
        removeAllActions()
        
        // Get the event position
        let targetPosition = event.position + (event.orientation * SCNVector3(0, 0, cameraDistance))
        let targetRotation = event.rotation
        
        // Focus on the event
        camera?.focusFovOnSize(WWDCEvent.slideSize, distance: cameraDistance)
        
        if (animated) {
            // Do the animation
            let duration: NSTimeInterval = 3
            let mv = SCNAction.moveTo(targetPosition, duration: duration)
            let rt = SCNAction.rotateToAxisAngle(targetRotation, duration: duration)
            mv.timingMode = .EaseInEaseOut
            rt.timingMode = .EaseInEaseOut
            runAction(SCNAction.group([ mv, rt ]))
        } else {
            // Move the camera
            position = targetPosition
        }
    }
}
