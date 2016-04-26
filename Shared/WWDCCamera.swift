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
    
    // The focus, used for look at constraints
    let focus: SCNNode
    
    var splineTime: CGFloat = 0
    
    override init() {
        // Create the focus
        focus = SCNNode()
        focus.position = SCNVector3(0, 0, -cameraDistance)
        
        super.init()
        
        // Add the focus
        addChildNode(focus)
        
        // Create the camera
        camera = SCNCamera()
        camera?.automaticallyAdjustsZRange = true
        
//        // Set up the depth of field
//        camera?.focalDistance = cameraDistance
//        camera?.focalBlurRadius = 6
//        camera?.focalSize = 2
//        camera?.aperture = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transitionToEvent(event: WWDCEvent, duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        // Remove any previous actions
        removeAllActions()
        
        // Get the event position
        let startTime = splineTime
        let targetTime = WWDCMainScene.singleton!.timeline.splineTimeForDate(event.date)
        let startRotation = eulerAngles
        let targetRotation = event.eulerAngles
        
        // Focus on the event
        camera?.focusFovOnSize(WWDCEvent.slideSize, distance: cameraDistance)
        
        // Do the animation
        runAction(
            SCNAction.customActionWithDuration(seconds: duration, method: method, mode: mode) {
                (node, progress) in
                // Interpolate the position
                if let timeline = WWDCMainScene.singleton?.timeline {
                    self.splineTime = CGFloat.lerp(startTime, end: targetTime, interpolation: progress) // Get the new time
                    node.position = timeline.positionForTime(self.splineTime) + // Get the position on the path
                        WWDCEvent.positionOffset + // Offset by the event position
                        (self.orientation * SCNVector3(0, 0, self.cameraDistance)) // Offset by the camera offset (to look a bit far back at the slide)
                }
                
                // Spherically interpolate the angles
                node.eulerAngles = SCNVector3(
                    CGFloat.slerp(startRotation.x, end: targetRotation.x, interpolation: progress),
                    CGFloat.slerp(startRotation.y, end: targetRotation.y, interpolation: progress),
                    CGFloat.slerp(startRotation.z, end: targetRotation.z, interpolation: progress)
                )
            }
        )
    }
}
