//
//  WWDCMainScene.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/18/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

// Inspired by WWDC '14 SceneKit session

class WWDCMainScene : SCNScene {
    let floor: WWDCFloor
    let timeline: WWDCTimeline
    
    override init() {
        
        // Create the floor
        floor = WWDCFloor()
        
        // Create the dates
        timeline = WWDCTimeline(
            startDate: WWDCDate(month: 0, year: 2010),
            endDate: WWDCDate(month: 5, year: 2016),
            spacing: 45,
            textSize: 7,
            dateHeight: 6,
            markers: [
                WWDCMarker(date: WWDCDate(month: 4, year: 2012), sceneName: "TestMarker")
            ]
        )
        
        super.init()
        
        // Add the nodes
        rootNode.addChildNode(floor)
        rootNode.addChildNode(timeline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Dates
    private let dateSpacing: Float = 3
    private let dateSize: Float = 3
    
    func nextSlide() {
        
    }
}