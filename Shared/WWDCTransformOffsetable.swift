//
//  WWDCTransformOffsetable.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/26/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

// Used for easy offset of transforms
protocol WWDCTransformOffsetable : class {
    // User set properties
    var basePosition: SCNVector3 { get set }
    var baseAngles: SCNVector3 { get set }
    var positionOffset: SCNVector3 { get set }
    var anglesOffset: SCNVector3 { get set }
    
    // SCNNode properties
    var eulerAngles: SCNVector3 { get set }
    var position: SCNVector3 { get set }
    var orientation: SCNQuaternion { get }
}

extension WWDCTransformOffsetable {
    // Commit the transforms
    func commitTransform() {
        eulerAngles = baseAngles // Set the base angle w/o offset so it properly offsets the position offset
        position = basePosition + (orientation * positionOffset) // Set position with transformed offset
        eulerAngles = baseAngles + anglesOffset // Add angle offset later
    }
}