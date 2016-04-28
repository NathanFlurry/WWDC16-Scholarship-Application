//
//  WWDCCamera.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCCamera : SCNNode, WWDCTransformOffsetable {
    // Distance the camera stays from each slide
    let cameraDistance = 10 as CGFloat
    
    // The focus, used for look at constraints
    let focus: SCNNode
    
    // Transform
    var splineTime = 0 as CGFloat // Time along the spline
    
    // Transform offsetable implementation
    var basePosition = SCNVector3()
    var baseAngles = SCNVector3()
    var positionOffset = SCNVector3()
    var anglesOffset = SCNVector3()
    
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
        let startPositionOffset = positionOffset
        let targetPositionOffset = event.positionOffset +
            SCNVector3(0, 0, self.cameraDistance) // Offset by the camera offset to be able to see the slide
        let startAnglesOffset = anglesOffset
        let targetAnglesOffset = event.anglesOffset
            
        
        // Focus on the event
        camera?.focusFovOnSize(event.slideSize, distance: cameraDistance)
        
        // Do the animation
        runAction(
            SCNAction.customActionWithDuration(seconds: duration, method: method, mode: mode) {
                (node, progress) in
                // Interpolate the position
                if let timeline = WWDCMainScene.singleton?.timeline {
                    // Adjust the camera values
                    self.splineTime = CGFloat.lerp(startTime, end: targetTime, interpolation: progress) // Offset time
                    
                    self.basePosition = timeline.positionForTime(self.splineTime) // Set base to the spline
                    self.baseAngles = timeline.rotationForTime(self.splineTime) // Set base to the spline
                    
                    self.positionOffset = SCNVector3.lerp(startPositionOffset, end: targetPositionOffset, interpolation: progress)
                    self.anglesOffset = SCNVector3.slerp(startAnglesOffset, end: targetAnglesOffset, interpolation: progress)
                    
                    // Commit the values
                    self.commitTransform()
                } else {
                    print("Could not get the timeline for WWDCCamera transition.")
                }
            }
        )
    }
}
