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
    // Dealing with hiding text and the date
    var hideTextAndDate: Bool = false {
        didSet {
            titleNode?.hidden = hideTextAndDate
            titleDateNode?.hidden = hideTextAndDate
            textNode?.hidden = hideTextAndDate
        }
    }
    
    // Detecting when at the same date as another
    let duplicateDatePositionOffset = SCNVector3(0, 1.5, -0.5)
    var duplicateDatesBefore: Int = 0 {
        didSet {
            positionOffset = positionOffset + duplicateDatePositionOffset * CGFloat(duplicateDatesBefore)
        }
    }
    
    // Sizing of the slide
    let absoluteSize = CGSize(width: 1920, height: 1200)
    let slideScale = 1 / 100 as CGFloat
    var slideSize: CGSize {
        return CGSize(width: absoluteSize.width * slideScale, height: absoluteSize.height * slideScale)
    }
    let textFlatness = 1 as CGFloat
    
    // Title metrics
    var titleNode: SCNNode?
    let titleFont = "SourceSansPro-Bold"
    let titleSize = 110 as CGFloat
    let titlePosition = SCNVector3(-910, 435, 0)
    
    // Title date metrics
    var titleDateNode: SCNNode?
    let titleDateFont = "SourceSansPro-Light"
    let titleDatePadding = 20 as CGFloat // Against the right of the title
    
    // Text metrics
    var textNode: SCNNode?
    let textFont = "SourceSansPro-Regular"
    let textSize = 60 as CGFloat
    let textPadding = 20 as CGFloat // Against the bottom of the title
    let textWidth = 1000 as CGFloat
    
    // Display panel
    var displayPanel: WWDCDisplayPanel?
    var displayPanelNode: SCNNode?
    let displayPanelSize = 600 as CGFloat
    var displayPanelPosition: SCNVector3 {
        return SCNVector3(
            (absoluteSize.width / 2  + (titlePosition.x + textWidth)) / 2,
            0, 0
        )
    }
    var displayPanelScale: SCNVector3 { // Scales the display panel
        let s = 1 / slideScale
        return SCNVector3(s, s, s)
    }
    
    // Parameters
    var title: String // The title of the slide
    var text: String
    var customHandler: WWDCEventHandler? // A custom handler that will be initiated
    
    init(date: WWDCDate, endDate: WWDCDate? = nil, title: String, text: String, media: WWDCDisplayPanelContents? = nil, customHandler: WWDCEventHandler? = nil) {
        self.title = title
        self.text = text
        self.customHandler = customHandler
        
        super.init()
        
        // Set the timeline item date
        self.date = date
        
        // Add the title
        (titleNode, _) = addText(
            title,
            fontName: titleFont,
            size: titleSize,
            position: titlePosition
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
                fontName: titleDateFont,
                size: titleSize,
                position: titlePosition + SCNVector3(v2.x - v1.x + titleDatePadding, 0, 0)
            )
        }
        
        // Add the text
        (textNode, _) = addText(
            text,
            fontName: textFont,
            size: textSize,
            position: SCNVector3(titlePosition.x, -absoluteSize.height / 2, 0),
            depth: 0,
            alignment: kCAAlignmentLeft,
            containerFrame: CGRect(
                x: 0,
                y: 0,
                width: textWidth,
                height: absoluteSize.height / 2 + titlePosition.y - textPadding
            )
        )
        
        // Add the media
        if let media = media {
            // Create the geometry
            displayPanel = WWDCDisplayPanel(contents: media, size: displayPanelSize * slideScale)
            displayPanel?.displayActive = false
            
            // Create the node
            displayPanelNode = SCNNode(geometry: displayPanel)
            displayPanelNode?.position = displayPanelPosition
            displayPanelNode?.scale = displayPanelScale
            
            // Add it as a child
            addChildNode(displayPanelNode!)
        }
        
        // Set the transforms
        scale = SCNVector3(slideScale, slideScale, slideScale)
        positionOffset = SCNVector3(-2, 5, 0)
        
        // Make transparent
        opacity = 0
        hidden = true
        
        // Assign to event in the custom handler (this will add any children and such)
        customHandler?.event = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Transform management
    
    // MARK: Text management
    private func addText(text: String, fontName: String, size: CGFloat, position: SCNVector3, depth: CGFloat = 0, alignment: String = kCAAlignmentLeft, containerFrame: CGRect? = nil) -> (SCNNode?, SCNText) {
        // Create the text geometry
        let text = SCNText(string: text, extrusionDepth: depth)
        text.font = WWDCFont(name: fontName, size: size)
        text.flatness = textFlatness
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
    
    // MARK: Transitions
    func fadeIn(delay: NSTimeInterval, duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode) {
        removeAllActions() // Remove previous actions
        let anim = SCNAction.fadeInWithDuration(duration) // Create the animation
        anim.timingFunction = SCNActionTimingMode.ease(method: method, mode: mode) // Set the timing mode
        hidden = false // Show the item
        displayPanel?.displayActive = true // Activate the display panel
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
                    SCNAction.runBlock {
                        $0.hidden = true // Hide the item
                        self.displayPanel?.displayActive = false // Disable the display panel
                    }
                ]
            )
        )
    }
}