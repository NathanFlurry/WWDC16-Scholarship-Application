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
    case Image(String), Video(String, String)
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
    private var contentSize: CGSize? {
        didSet {
            updateGeometry()
        }
    }
    private var player: AVPlayer?
    
    init(contents: WWDCDisplayPanelContents, size: CGFloat) { // Size is the size to fit the box in
        self.contents = contents
        self.size = size
        
        super.init()
        
        // Load the data (which sets the geometry)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadData() {
        // Get the material contents and data
        var materialContents: AnyObject?
        switch contents {
        case .Image(let imageName):
            // Get the image
            let image = WWDCImage(named: imageName)
            
            // Set the size
            contentSize = image?.size
            
            // Set the material contents
            materialContents = image
        case .Video(let videoName, let videoExtension):
            // Get the URL
            if let url = NSBundle.mainBundle().URLForResource(videoName, withExtension: videoExtension) {
                materialContents = generatePlayer(url)
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
            print("No content size set for WWDCDisplayPanel.")
        }
    }
    
    private func generatePlayer(url: NSURL) -> CALayer? {
        // Create the player
        let player = AVPlayer(URL: url)
        self.player = player
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: Selector("hello:"),
//            name: AVPlayerItemDidPlayToEndTimeNotification,
//            object: player.currentItem
//        )
        
        // Loop the video
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVPlayerItemDidPlayToEndTimeNotification,
            object: player.currentItem,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: WWDCDisplayPanel.playerLoopBlock
        )
        
        // Play
        player.play()
        
        // Get the video size
        let trackSize: CGSize
        if let track = player.currentItem?.asset.tracks[0] {
            trackSize = track.naturalSize
            contentSize = trackSize
        } else {
            print("Could not get the track for WWDCDisplayPanel.")
            return nil
        }
        
        // Create the player layer
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.frame = CGRect(origin: CGPointZero, size: trackSize) // TODO: Resize
        
        // Create the background layer
        let backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = WWDCColor.blackColor().CGColor
        backgroundLayer.frame = playerLayer.frame
        backgroundLayer.addSublayer(playerLayer)
        
        // Return the layer
        return backgroundLayer
    }
}