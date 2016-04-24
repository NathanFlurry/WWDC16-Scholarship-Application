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
    let view: SCNView
    
    private var currentSlide: Int = -1
    var slide: Int {
        return currentSlide
    }
    
    let camera: WWDCCamera
    
    let floor: WWDCFloor
    let timeline: WWDCTimeline
    
    init(sceneView: SCNView) {
        // Save the view
        self.view = sceneView
        
        // Create the floor
        floor = WWDCFloor()
        
        // Create the dates
        do {
            timeline = WWDCTimeline(
                timelineItems: [
                    try WWDCMarker(date: WWDCDate(month: 4, year: 2012), sceneName: "TestMarker"),
                    try WWDCMarker(date: WWDCDate(month: 5, year: 2012), sceneName: "TestMarker"),
                    try WWDCMarker(date: WWDCDate(month: 6, year: 2012), sceneName: "TestMarker"),
                    
                    WWDCEvent(
                        date: WWDCDate(month: 7, year: 2012),
                        title: "More events",
                        text: "Just some text over here, trying to reach the wrap limit.\nThis might be a bit long, but whatever.",
                        customHandler: nil
                    ),
                    WWDCEvent(
                        date: WWDCDate(month: 3, year: 2013),
                        title: "This is the title",
                        text: "Here is some semi-long text in here with some stuff and\nthis is a new line\njust\nfor\nfun",
                        customHandler: nil
                    ),
                    WWDCEvent(
                        date: WWDCDate(month: 11, year: 2015),
                        title: "Another title",
                        text: "Yayayayayayayayayayayayayaya cool stuff WWDC yeah\nmhmm",
                        customHandler: nil
                    )
                ]
            )
        } catch {
            timeline = WWDCTimeline(timelineItems: [])
            print("Could not create timeline. \(error)")
        }
        
        // Create the camera
        camera = WWDCCamera()
        
        super.init()
        
        // Add the nodes
//        rootNode.addChildNode(floor)
        rootNode.addChildNode(timeline)
        
        // Add the camera
        rootNode.addChildNode(camera)
        transitionToIndex(0, animated: false)
        sceneView.pointOfView = camera
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Dates
    private let dateSpacing: Float = 3
    private let dateSize: Float = 3
    
    func transitionToIndex(index: Int, animated: Bool = true) {
        // Check the index is in range
        guard index < timeline.events.count && index >= 0 else {
            print("Slide index \(index) out of range.")
            return
        }
        
        // Transition the camera to the event
        camera.transitionToEvent(timeline.events[index], animated: animated)
        
        // Save the index
        currentSlide = index
    }
    
    func nextSlide(animated: Bool = true) {
        transitionToIndex(slide + 1, animated: animated)
    }
    
    func previousSlide(animated: Bool = true) {
        transitionToIndex(slide - 1, animated: animated)
    }
}