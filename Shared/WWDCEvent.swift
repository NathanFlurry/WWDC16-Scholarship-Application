//
//  WWDCEvent.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/20/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

protocol WWDCEventHandler {
    // Handlers for when the slide became active and inactive
    func becameActive()
    func becameInactive()
    
    // Called when going to the next slide, returns true if complete
    func nextAndComplete() -> Bool
}

class WWDCEvent : WWDCTimelineItem {
    // Position of the slide
    static let positionOffset = SCNVector3(-10, 0, 0)
    
    // Sizing of the slide
    static let absoluteSize = CGSize(width: 1920, height: 1200)
    static let slideScale: CGFloat = 1 / 100
    static var slideSize: CGSize {
        return CGSize(width: absoluteSize.width * slideScale, height: absoluteSize.height * slideScale)
    }
    
    // Title metrics
    static let titleFont = "SourceSansPro-Bold"
    static let titleSize: CGFloat = 110
    static let titlePosition = SCNVector3(-910, 435, 0)
    
    // Bullet metrics
    static let textFont = "SourceSansPro-Regular"
    static let textSize: CGFloat = 95
    static let textPadding: CGFloat = 40 // Against the bottom of the title
    static let textWidth: CGFloat = 1000
    
    // Parameters
    var title: String // The title of the slide
    var text: String
    var customHandler: WWDCEventHandler.Type? // A custom handler that will be initiated
    
    init(date: WWDCDate, title: String, text: String, customHandler: WWDCEventHandler.Type?) {
        self.title = title
        self.text = text
        self.customHandler = customHandler
        
        super.init()
        
        self.date = date
        
        // Add a base plane
        let plane = SCNPlane(width: WWDCEvent.slideSize.width, height: WWDCEvent.slideSize.height)
        plane.cornerRadius = 0.5
        let planeNode = SCNNode(geometry: plane)
        planeNode.position.z = -0.01
        plane.firstMaterial?.diffuse.contents = WWDCColor(white: 0.1, alpha: 1.0)
        addChildNode(planeNode)
        
        // Add the title
        addText(
            title,
            fontName: WWDCEvent.titleFont,
            size: WWDCEvent.titleSize,
            position: WWDCEvent.titlePosition
        )
        
        // Add the text
        addText(
            text,
            fontName: WWDCEvent.textFont,
            size: WWDCEvent.textSize,
            position: SCNVector3(WWDCEvent.titlePosition.x, -WWDCEvent.absoluteSize.height / 2, 0),
            depth: 0,
            alignment: kCAAlignmentLeft,
            containerFrame: CGRect(
                x: 0,
                y: 0,
                width: WWDCEvent.textWidth,
                height: WWDCEvent.absoluteSize.height / 2 + WWDCEvent.titlePosition.y - WWDCEvent.textPadding
            )
        )
        
        // Position the event
        position = WWDCEvent.positionOffset
    }
    
    private func addText(text: String, fontName: String, size: CGFloat, position: SCNVector3, depth: CGFloat = 0, alignment: String = kCAAlignmentLeft, containerFrame: CGRect? = nil) {
        // Create the text geometry
        let text = SCNText(string: text, extrusionDepth: depth)
        text.font = WWDCFont(name: fontName, size: size * WWDCEvent.slideScale)
        text.flatness = 0
        text.alignmentMode = alignment
        
        if let frame = containerFrame {
            text.containerFrame = CGRect(
                x: frame.origin.x * WWDCEvent.slideScale,
                y: frame.origin.y * WWDCEvent.slideScale,
                width: frame.width * WWDCEvent.slideScale,
                height: frame.height * WWDCEvent.slideScale
            )
            text.wrapped = true
            text.truncationMode = kCATruncationNone
        }
        
        // Create the node
        let textNode = SCNNode(geometry: text)
        textNode.position = position * WWDCEvent.slideScale
        
        addChildNode(textNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}