//
//  WWDCMarker.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/20/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCMarker : WWDCTimelineItem {
    var sceneName: String
    
    init(date: WWDCDate, sceneName: String) throws {
        self.sceneName = sceneName
        
        super.init()
        
        self.date = date
        
        // Attempt to load the scene
        do {
            let scene = try loadScene() // Get the scene
            for child in scene.rootNode.childNodes { // Add all the children
                addChildNode(child)
            }
        } catch {
            throw WWDCError(message: "Could not get marker scene \"" + sceneName + "\".")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadScene() throws -> SCNScene {
        do {
            // Get the path
            let path = NSBundle.mainBundle().URLForResource("SceneAssets.scnassets/" + sceneName, withExtension: "scn")
            if path == nil { throw NSError(domain: "", code: 0, userInfo: nil) } // TODO: Get proper errors
            
            // Get the scene source
            if let scnSource = SCNSceneSource(URL: path!, options: nil) {
                // Return the scene
                return try scnSource.sceneWithOptions(nil)
            } else {
                // No scene source
                throw NSError(domain: "", code: 0, userInfo: nil) // TODO: Get proper errors
            }
        } catch {
            // Throw the error to the caller
            throw error
        }
    }
}