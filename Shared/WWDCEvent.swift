//
//  WWDCEvent.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/20/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

enum WWDCEventBullet {
    case Text(String), Indent([WWDCEventBullet])
}

protocol WWDCEventHandler {
    // Handlers for when the slide became active and inactive
    func becameActive()
    func becameInactive()
    
    // Called when going to the next slide, returns true if complete
    func nextAndComplete() -> Bool
}

class WWDCEvent : WWDCTimelineItem {
    private static let bulletString = " • "
    
    // Position of the slide
    static let positionOffset = SCNVector3(-10, 0, 0)
    
    // Sizing of the slide
    static let absoluteSize = CGSize(width: 1920, height: 1200)
    static let slideScale: CGFloat = 1 / 200
    static var slideSize: CGSize {
        return CGSize(width: absoluteSize.width * slideScale, height: absoluteSize.height * slideScale)
    }
    
    // Title metrics
    static let titleFont = "Source Sans Pro Bold"
    static let titleSize: CGFloat = 110
    static let titlePosition = SCNVector3(-910, 435, 100)
    
    // Bullet metrics
    static let bulletFont = "Source Sans Pro Semibold"
    static let bulletSize: CGFloat = 95
    static let bulletPosition = SCNVector3(-910, 300, 100)
    static let bulletLineHeight: CGFloat = 190
    static let bulletIndentSize: CGFloat = 90
    
    // Parameters
    var title: String // The title of the slide
    var bullets: [WWDCEventBullet] // Bullets within the slide
    var customHandler: WWDCEventHandler.Type? // A custom handler that will be initiated
    
    init(title: String, date: WWDCDate, bullets: [WWDCEventBullet], customHandler: WWDCEventHandler.Type?) {
        self.title = title
        self.bullets = bullets
        self.customHandler = customHandler
        
        super.init()
        
        self.date = date
        
        // Add a base plane
        let plane = SCNPlane(width: WWDCEvent.slideSize.width, height: WWDCEvent.slideSize.height)
        plane.cornerRadius = 0.5
        let planeNode = SCNNode(geometry: plane)
        planeNode.position.z = -3
        plane.firstMaterial?.diffuse.contents = WWDCColor(white: 0.1, alpha: 1.0)
        addChildNode(planeNode)
        
        // Add the title
        
        // Add the bullets
        addBullets(bullets)
        
        // Position the event
        position = WWDCEvent.positionOffset
    }
    
    private func addBullets(bullets: [WWDCEventBullet], index i: Int = 0, indentationLevel: Int = 0) {
        var index = i
        for bullet in bullets {
            // Deal with the bullet
            switch bullet {
            case .Text(let title):
                addBullet(title, index: index, indentationLevel: indentationLevel)
            case .Indent(let childBullets):
                addBullets(childBullets, index: index, indentationLevel: indentationLevel + 1)
            }
            
            // Increment the index
            index += 1
        }
    }
    
    private func addBullet(text: String, index: Int, indentationLevel: Int) {
        addText(
            text,
            fontName: WWDCEvent.bulletFont,
            size: WWDCEvent.bulletSize,
            position: WWDCEvent.bulletPosition + SCNVector3(
                WWDCEvent.bulletIndentSize * CGFloat(indentationLevel),
                -WWDCEvent.bulletLineHeight * CGFloat(index),
                0
            )
        )
    }
    
    private func addText(text: String, fontName: String, size: CGFloat, position: SCNVector3, depth: CGFloat = 0, alignment: String = kCAAlignmentLeft, containerFrame: CGRect? = nil) {
        // Create the text geometry
        let text = SCNText(string: text, extrusionDepth: depth)
        text.font = Font(name: fontName, size: size * WWDCEvent.slideScale)
        text.alignmentMode = alignment
        if let frame = containerFrame {
            text.containerFrame = frame
            text.wrapped = true
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