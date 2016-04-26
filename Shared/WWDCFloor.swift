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
    
    override init() {
        // Create the floor
        floor = SCNFloor()
        floor.reflectionFalloffStart = 0
        floor.reflectionFalloffEnd = 15
        
        let floorMaterial = floor.firstMaterial!
//        floorMaterial.diffuse.contents = "Floor.jpg"
        floorMaterial.diffuse.contents = WWDCColors.charade
        floorMaterial.locksAmbientWithDiffuse = true
        floorMaterial.normal.contents = "NormalMap.png"
        floorMaterial.normal.intensity = 0.5
        floor.firstMaterial = floorMaterial
        
        
        super.init()
        
        // Set the geometry
        geometry = floor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}