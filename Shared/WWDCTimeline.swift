//
//  WWDCTimeline.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/19/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

struct WWDCDate {
    var month: Int // 0-11
    var year: Int
}

enum WWDCEventBullet {
    case Text(String), Indent([WWDCEventBullet])
}

struct WWDCEvent {
    private static let bulletString = " • "
    
    var title: String
    var bullets: [WWDCEventBullet]
}

struct WWDCMarker {
    var date: WWDCDate
    var sceneName: String
    
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

class WWDCTimeline : SCNNode {
    private static let months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
    
    // Dates
    private var datesNode: SCNNode
    private var startDate: WWDCDate
    private var endDate: WWDCDate
    private var spacing: CGFloat
    private var textSize: CGFloat
    private var dateHeight: CGFloat
    
    // Events
    private var markersNode: SCNNode
    private var markers: [WWDCMarker]
    
    init(startDate start: WWDCDate, endDate end: WWDCDate, spacing space: CGFloat, textSize size: CGFloat, dateHeight height: CGFloat, markers markerList: [WWDCMarker]) {
        // Manage dates
        datesNode = SCNNode()
        datesNode.position = SCNVector3(0, height, 0) // Move up by the date height
        startDate = start
        endDate = end
        spacing = space
        textSize = size
        dateHeight = height
        
        // Manage events
        markersNode = SCNNode()
        markers = markerList
        
        super.init()
        
        // Add the nodes
        addChildNode(datesNode)
        addChildNode(markersNode)
        
        // Generate the dates
        for year in startDate.year...endDate.year {
            // Generate the year text
            generateDate(WWDCDate(month: 0, year: year), isYear: true)
            
            for month in (year == startDate.year ? startDate.month : 0)...(year == endDate.year ? endDate.month : 11) {
                // Generate the month text
                generateDate(WWDCDate(month: month, year: year), isYear: false)
            }
        }
        
        // Generate the events
        for event in markers {
            do {
                let scene = try event.loadScene() // Get the scene
                let markerNode = SCNNode() // Make a node to put all the event's children in
                for child in scene.rootNode.childNodes { // Add all the children
                    markerNode.addChildNode(child)
                }
                markerNode.position = SCNVector3(distanceForDate(event.date), 0, 0) // Move to the correct position
                markersNode.addChildNode(markerNode) // Add the event node
            } catch {
                print("Could not get marker scene \"" + event.sceneName + "\"")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateDate(date: WWDCDate, isYear: Bool) -> SCNNode {
        // Create the text
        let dateText = SCNText(string: isYear ? "\(date.year)" : WWDCTimeline.months[date.month], extrusionDepth: 1)
        dateText.font = NSFont.systemFontOfSize(textSize, weight: isYear ? 1 : 0)
        dateText.flatness = 0
        
        // Create the date node
        let dateNode = SCNNode(geometry: dateText)
        dateNode.position = SCNVector3(distanceForDate(date), isYear ? textSize * 1.5 : 0, 0) // Move up if is a year marker
        dateNode.eulerAngles = SCNVector3(0, isYear ? M_PI * 0.4 : M_PI * 0.6, 0) // Turn the date slightly
        
        // Add the node
        datesNode.addChildNode(dateNode)
        
        // Return the node
        return dateNode
    }
    
    private func distanceForDate(date: WWDCDate) -> CGFloat {
        return CGFloat((date.year - startDate.year) * 12 + date.month) * spacing
    }
}