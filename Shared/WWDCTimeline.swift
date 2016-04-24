//
//  WWDCTimeline.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/19/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCTimelineItem : SCNNode { // Swift desprately needs abstract classes, protocols don't cut it
    // The date the timeline item is at
    var date: WWDCDate = WWDCDate(absoluteMonth: 0)
}


class WWDCTimeline : SCNNode {
    private static let months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
    
    // Dates
    let datesNode: SCNNode
    let startDate: WWDCDate
    let endDate: WWDCDate
    let dateRangePadding = 4 // In months
    let dateSpacing: CGFloat = 45
    let textSize: CGFloat = 2
    let dateHeight: CGFloat = 0.5
    
    // Items
    let timelineItemsNode: SCNNode
    let timelineItems: [WWDCTimelineItem]
    
    // Filtered items
    private var cachedEvents: [WWDCEvent]?
    var events: [WWDCEvent] {
        if let evts = cachedEvents { // Events are already cached, return those
            return evts
        } else { // Filter the timeline items for events, save them to the cache, and return them
            let evts = timelineItems.filter({ $0 is WWDCEvent }) // as! [WWDCEvent] // Should work
            cachedEvents = [WWDCEvent]()
            for e in evts {
                cachedEvents?.append(e as! WWDCEvent)
            }
            return cachedEvents!
        }
    }
//    private var cachedMarkers: [WWDCMarker]?
//    var markers: [WWDCMarker] {
//        if let mks = cachedMarkers { // Markers are already cached, return those
//            return mks
//        } else { // Filter the timeline items for markers, save them to the cache, and return them
//            let mks = timelineItems.filter({ $0 is WWDCMarker }) // as! [WWDCMarker] // Should work
//            cachedMarkers = [WWDCMarker]()
//            for m in mks {
//                cachedMarkers?.append(m as! WWDCMarker)
//            }
//            return cachedMarkers!
//        }
//    }
    
    init(timelineItems items: [WWDCTimelineItem]) {
        // Manage dates
        datesNode = SCNNode()
        datesNode.position = SCNVector3(0, dateHeight, 0) // Move up by the date height
        
        // Manage timeline
        timelineItemsNode = SCNNode()
        timelineItems = items.sort { return $0.date < $1.date } // Set to sorted items based on dates
        
        // Find the minimum and maximum dates based on events
        var minDate = WWDCDate.max
        var maxDate = WWDCDate.min // Who knows, we may have some event from before 0 A.D. :P
        for item in timelineItems {
            if item.date < minDate { minDate = item.date }
            if item.date > maxDate { maxDate = item.date }
        }
        startDate = minDate - dateRangePadding
        endDate = maxDate + dateRangePadding
        
        super.init()
        
        // Add the nodes
        addChildNode(datesNode)
        addChildNode(timelineItemsNode)
        
        // Generate the dates
        for year in startDate.year...endDate.year {
            // Generate the year text
            generateDate(WWDCDate(month: 0, year: year), isYear: true)
            
            for month in (year == startDate.year ? startDate.month : 0)...(year == endDate.year ? endDate.month : 11) {
                // Generate the month text
                generateDate(WWDCDate(month: month, year: year), isYear: false)
            }
        }
        
        // Generate the items
        for item in timelineItems {
            // Get the node
            item.position = positionForDate(item.date) + item.position
            timelineItemsNode.addChildNode(item)
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
        dateNode.position = positionForDate(date) + SCNVector3(x: 0, y: isYear ? textSize * 1.5 : 0, z: 0) // Move up if is a year marker
        dateNode.eulerAngles = SCNVector3(0, isYear ? M_PI * 0.4 : M_PI * 0.6, 0) // Turn the date slightly
        
        // Add the node
        datesNode.addChildNode(dateNode)
        
        // Return the node
        return dateNode
    }
    
    func distanceForDate(date: WWDCDate) -> CGFloat { // Returns the distance in the world space that a date should be moved in the x direction
        return CGFloat((date.year - startDate.year) * 12 + date.month) * dateSpacing
    }
    
    func positionForDate(date: WWDCDate) -> SCNVector3 {
        return SCNVector3(0, 0, -distanceForDate(date))
    }
}