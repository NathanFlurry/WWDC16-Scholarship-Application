//
//  WWDCDisplayPanel.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/26/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit
import AVFoundation

enum WWDCDisplayPanelContents {
    case Image(String, String), Video(String, String)
    
    func getUrl(prefix: String = "") -> NSURL? { // Returns the URL for the resource
        var fileName: String?
        var fileExt: String?
        switch self {
        case .Image(let name, let ext):
            fileName = name
            fileExt = ext
        case .Video(let name, let ext):
            fileName = name
            fileExt = ext
        }
        return NSBundle.mainBundle().URLForResource(fileName != nil ? prefix + fileName! : nil, withExtension: fileExt)
    }
}

class WWDCDisplayPanel : SCNPlane {
    // Block used to loop video
    static let playerLoopBlock: (NSNotification) -> Void = {
        (notification) in
        // Seek to the beginning
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seekToTime(kCMTimeZero)
        }
    }
    
    // Determines if the display is active
    var displayActive = true {
        didSet {
            if displayActive {
                // Reset video
                player?.seekToTime(kCMTimeZero)
                player?.play()
            } else {
                // Pause the video
                player?.pause()
            }
        }
    }
    
    // Geometry properties
    var contents: WWDCDisplayPanelContents {
        didSet {
            loadData()
            // Load data will set the content size which will call updateGeometry()
        }
    }
    var size: CGFloat {
        didSet {
            updateGeometry()
        }
    }
    var cornerPercentRadius = 0.06 as CGFloat {
        didSet {
            updateGeometry()
        }
    }
    
    // Private properties
    private let queue: NSOperationQueue
    private var contentSize: CGSize? {
        didSet {
            updateGeometry()
        }
    }
    private var player: AVPlayer?
    
    init(contents: WWDCDisplayPanelContents, size: CGFloat) { // Size is the size to fit the box in
        self.contents = contents
        self.size = size
        
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        super.init()
        
        // Load the data (which sets the geometry)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadData() {
        // Get the material contents and data
        let eventMediaBase: String = "EventMedia.scnassets/"
        var materialContents: AnyObject?
        switch contents {
        case .Image(_, _):
            // Get the image
            if let url = contents.getUrl(eventMediaBase), data = NSData(contentsOfURL: url) {
                // Get the image
                let image = WWDCImage(data: data)

                // Set the size
                contentSize = image?.size

                // Set the material contents
                materialContents = image
            } else {
                print("Could not get URL for \(contents).")
            }
        case .Video(_, _):
            // Get the URL
            if let url = contents.getUrl(eventMediaBase) {
                materialContents = generatePlayer(url)
            } else {
                print("Could not get URL for \(contents).")
            }
        }
        
        // Assign the contents
        firstMaterial?.emission.contents = materialContents
    }
    
    private func updateGeometry() {
        if let s = contentSize {
            // Get the scale factor
            let scaleFactor = size / (s.width > s.height ? s.width : s.height)
            
            // Set the size
            width = s.width * scaleFactor
            height = s.height * scaleFactor
            
            // Set the corner radius
            cornerRadius = cornerPercentRadius * (width < height ? width : height)
        } else {
//            print("No content size set for WWDCDisplayPanel.")
        }
    }
    
    private func generatePlayer(url: NSURL) -> /*SKScene?*/ CALayer? { // FIXME: For some reason, this creates black bar under videos
        
        // Create the background layer
        let backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = WWDCColor.redColor().CGColor // TODO: Add back
        backgroundLayer.frame = CGRectZero
        
        // Load the video and add it as a sublayer
        queue.addOperationWithBlock {
            // Create the player
            let player = AVPlayer(URL: url)
            self.player = player
            player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
            
            // Loop the video
            NSNotificationCenter.defaultCenter().addObserverForName(
                AVPlayerItemDidPlayToEndTimeNotification,
                object: player.currentItem,
                queue: NSOperationQueue.mainQueue(),
                usingBlock: WWDCDisplayPanel.playerLoopBlock
            )
            
            // Play the video
            player.play()
            
            // Get the track itself
            guard let track = player.currentItem?.asset.tracks[0] else {
                print("Could not get the track for WWDCDisplayPanel.")
                return
            }
            
            // Get the track size
            let trackSize = track.naturalSize
            self.contentSize = trackSize
            
            // Create the player layer on the main thread
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.videoGravity = AVLayerVideoGravityResize
                playerLayer.frame = CGRect(origin: CGPointZero, size: trackSize)
                backgroundLayer.frame = playerLayer.frame // Resize background
                backgroundLayer.addSublayer(playerLayer) // Add player layer
            }
        }
        
        // Return the layer
        return backgroundLayer
    }
}