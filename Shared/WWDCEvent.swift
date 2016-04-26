//
//  WWDCEvent.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/20/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

protocol WWDCEventHandler : class {
    // The event handling it (use didSet to add children to the event)
    var event: WWDCEvent? { get set }
    
    // Handlers for when the slide became active and inactive
//    func becameActive()
//    func becameInactive()
    
    // Transitions
    func transitionIn(delay: NSTimeInterval, duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode)
    func transitionOut(duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode)
    
    // Called when going to the next slide, returns true if complete
    func nextAndComplete() -> Bool
}

class WWDCEvent : WWDCTimelineItem {
    // Position of the slide
    static let positionOffset = SCNVector3(-2, 5, 0)
    
    // Dealing with hiding text and the date
    var hideTextAndDate: Bool = false {
        didSet {
            titleNode?.hidden = hideTextAndDate
            titleDateNode?.hidden = hideTextAndDate
            textNode?.hidden = hideTextAndDate
        }
    }
    
    // Sizing of the slide
    static let absoluteSize = CGSize(width: 1920, height: 1200)
    static let slideScale: CGFloat = 1 / 100
    static var slideSize: CGSize {
        return CGSize(width: absoluteSize.width * slideScale, height: absoluteSize.height * slideScale)
    }
    static let textFlatness: CGFloat = 1
    
    // Title metrics
    var titleNode: SCNNode?
    static let titleFont = "SourceSansPro-Bold"
    static let titleSize: CGFloat = 110
    static let titlePosition = SCNVector3(-910, 435, 0)
    
    // Title date metrics
    var titleDateNode: SCNNode?
    static let titleDateFont = "SourceSansPro-Light"
    static let titleDatePadding: CGFloat = 20 // Against the right of the title
    
    // Text metrics
    var textNode: SCNNode?
    static let textFont = "SourceSansPro-Regular"
    static let textSize: CGFloat = 60
    static let textPadding: CGFloat = 20 // Against the bottom of the title
    static let textWidth: CGFloat = 1000
    
    // Parameters
    var title: String // The title of the slide
    var text: String
    var customHandler: WWDCEventHandler? // A custom handler that will be initiated
    
    init(date: WWDCDate, endDate: WWDCDate?, title: String, text: String, customHandler: WWDCEventHandler? = nil) {
        self.title = title
        self.text = text
        self.customHandler = customHandler
        
        super.init()
        
        // Set the timeline item date
        self.date = date
        
        // Add the title
        (titleNode, _) = addText(
            title,
            fontName: WWDCEvent.titleFont,
            size: WWDCEvent.titleSize,
            position: WWDCEvent.titlePosition
        )
        
        // Add the title date
        do {
            // Get bounding box of title to see how far to push date
            var v1 = SCNVector3(0, 0, 0)
            var v2 = SCNVector3(0, 0, 0)
            titleNode?.getBoundingBoxMin(&v1, max:&v2)
            
            // Add the date
            (titleDateNode, _) = addText(
                date.description + (endDate != nil ? " - \(endDate!.description)" : ""),
                fontName: WWDCEvent.titleDateFont,
                size: WWDCEvent.titleSize,
                position: WWDCEvent.titlePosition + SCNVector3(v2.x - v1.x + WWDCEvent.titleDatePadding, 0, 0)
            )
        }
        
        // Add the text
        (textNode, _) = addText(
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
        
        // Position and scale the event
        position = WWDCEvent.positionOffset
        scale = SCNVector3(WWDCEvent.slideScale, WWDCEvent.slideScale, WWDCEvent.slideScale)
        
        // Make transparent
        opacity = 0
        
        // Assign to event in the custom handler (this will add any children and such)
        customHandler?.event = self
    }
    
    convenience init(date: WWDCDate, title: String, text: String, customHandler: WWDCEventHandler? = nil) {
        self.init(date: date, endDate: nil, title: title, text: text, customHandler: customHandler)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addText(text: String, fontName: String, size: CGFloat, position: SCNVector3, depth: CGFloat = 0, alignment: String = kCAAlignmentLeft, containerFrame: CGRect? = nil) -> (SCNNode?, SCNText) {
        // Create the text geometry
        let text = SCNText(string: text, extrusionDepth: depth)
        text.font = WWDCFont(name: fontName, size: size)
        text.flatness = WWDCEvent.textFlatness
        text.alignmentMode = alignment
        
        // Set the container frame, if needed
        if let frame = containerFrame {
            text.containerFrame = CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
            text.wrapped = true
            text.truncationMode = kCATruncationNone
        }
        
        // Set the material
        text.firstMaterial?.diffuse.contents = WWDCColor.whiteColor()
        text.firstMaterial?.emission.contents = WWDCColor.whiteColor()
        
        // Create the node
        let textNode = SCNNode(geometry: text)
        textNode.position = position
        
        addChildNode(textNode)
        
        return (textNode, text)
    }
    
    func fadeIn(delay: NSTimeInterval, duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        removeAllActions() // Remove previous actions
        let anim = SCNAction.fadeInWithDuration(duration) // Create the animation
        anim.timingFunction = SCNActionTimingMode.ease(method: method, mode: mode) // Set the timing mode
        hidden = false // Show the item
        runAction( // Run action with a delay
            SCNAction.sequence(
                [
                    SCNAction.waitForDuration(delay),
                    anim
                ]
            )
        )
    }
    
    func fadeOut(duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        removeAllActions() // Remove previous actions
        let anim = SCNAction.fadeOutWithDuration(duration) // Create the animation
        anim.timingFunction = SCNActionTimingMode.ease(method: method, mode: mode) // Set the timing mode
        runAction( // Run action then hide
            SCNAction.sequence(
                [
                    anim,
                    SCNAction.runBlock { $0.hidden = true }
                ]
            )
        )
    }
}