//
//  WWDCFloor.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/19/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCFloor : SCNNode {
    // Nodes
    private let floor: SCNFloor
    
    // Parameters
//    var color: CGColor? {
//        get {
//            return floor.firstMaterial?.diffuse.contents
//        }
//        set {
//            floor.firstMaterial?.diffuse.contents = newValue
//        }
//    }
    var falloffStart: CGFloat {
        get {
            return floor.reflectionFalloffStart
        }
        set {
            floor.reflectionFalloffStart = newValue
        }
    }
    var falloffEnd: CGFloat {
        get {
            return floor.reflectionFalloffEnd
        }
        set {
            floor.reflectionFalloffStart = newValue
        }
    }
    
    override init() {
        // Create the floor
        floor = SCNFloor()
        floor.reflectionFalloffStart = 0
        floor.reflectionFalloffEnd = 15
        
        super.init()
        
        // Set the geometry
        geometry = floor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}