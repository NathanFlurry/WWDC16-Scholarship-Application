//
//  WWDCTimeline.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/19/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class WWDCTimelineItem : SCNNode, WWDCTransformOffsetable { // Swift desprately needs abstract classes, protocols don't cut it
    // The date the timeline item is at
    var date: WWDCDate = WWDCDate(absoluteMonth: 0)
    
    // The transform bases and offsets of the object
    var basePosition = SCNVector3() {
        didSet {
            commitTransform()
        }
    }
    var baseAngles = SCNVector3() {
        didSet {
            commitTransform()
        }
    }
    var positionOffset = SCNVector3() {
        didSet {
            commitTransform()
        }
    }
    var anglesOffset = SCNVector3() {
        didSet {
            commitTransform()
        }
    }
}


class WWDCTimeline : SCNNode {
    // Spline in which to put everything on
    let timelineSpline: WWDCSpline
    
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
    
    init(timelineItems items: [WWDCTimelineItem], timelineSpline spline: WWDCSpline) {
        // Manage dates
        datesNode = SCNNode()
        datesNode.position = SCNVector3(0, dateAltitude, 0) // Move up by the date height
        timelineSpline = spline
        
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
        
        // Generate the dates
        generateDates()
        
        // Generate the items
        generateItems()
        
        // Add the nodes
        addChildNode(datesNode.flattenedClone())
        addChildNode(timelineItemsNode) // Not flattened, since opacity and hidden-ness is modified at runtime
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Dates
    let datesNode: SCNNode // Node which all the dates are under
    let startDate: WWDCDate // The starting date for all the date objects
    let endDate: WWDCDate // The ending date
    let dateRangePadding = 0 // Months around the first and last items that the dates should still be created
    
    let dateFontName = "SourceSansPro-Regular"
    let dateYearFontName = "SourceSansPro-Bold"
    let dateTextSize = 80 as CGFloat // Font side for dates
    let dateScale = 0.02 as CGFloat // Scale for the date objects
    var dateScaleVector: SCNVector3 { return SCNVector3(dateScale, dateScale, dateScale) }
    let dateExtrusionDepth = 15 as CGFloat // Extrusion amount for the dates
    let dateFlatness = 0.3 as CGFloat // Flatness for the dates
    let dateChamfer = 2 as CGFloat // Chamfer for the dates
    let dateAltitude = 0 as CGFloat // Height above the ground
    
    private func generateDates() {
        // Get the fonts
        let dateFont = WWDCFont(name: dateFontName, size: dateTextSize)
        let yearFont = WWDCFont(name: dateYearFontName, size: dateTextSize)
        
        // Make the base date
        let dateBase = SCNText(string: "", extrusionDepth: dateExtrusionDepth)
        dateBase.font = dateFont
        dateBase.flatness = dateFlatness
        dateBase.chamferProfile = straightChamferProfile
        dateBase.chamferRadius = dateChamfer
        
        // Generate the materials
        let frontMaterial = SCNMaterial()
        let sideMaderial = SCNMaterial()
        frontMaterial.diffuse.contents = WWDCColor.whiteColor()
        frontMaterial.emission.contents = WWDCColor.lightGrayColor()
        sideMaderial.diffuse.contents = WWDCColor.lightGrayColor()
        dateBase.materials = [frontMaterial, frontMaterial, sideMaderial, frontMaterial, frontMaterial ]
        
        // Generate the date geometries
        var monthGeometries = [SCNText]()
        for i in 0...11 {
            do {
                // FIXME: Calling SCNText.copy() throws an EXC_BAD_ACCESS exception unpredictably, sometimes when mutating the object, other times when copying
                // FIXME: Calling SCNText.mutableCopy() gives SCNMutableGeometry, which I don't have access to and SCNText does not conform to
                // Create the month text
                let text = try dateBase.archiveCopy() // FIXME: Stop using archiveCopy()
                text.string = WWDCDate.months[i]
                
                // Add to the geometries
                monthGeometries += [ text ]
            } catch {
                print("Could not copy date base for month. \(error)")
            }
        }
        
        // Generate the dates
        for year in startDate.year...endDate.year {
            do {
                if year != startDate.year && startDate.month != 0 { // Don't add on beginning
                    // Generate the year text
                    let text = try dateBase.archiveCopy() // FIXME: Stop using archiveCopy()
                    text.string = "\(year)"
                    text.font = yearFont
                    
                    // Generate the year node
                    let yearNode = SCNNode(geometry: text)
                    yearNode.position = positionForDate(WWDCDate(month: 0, year: year)) + SCNVector3(0, dateTextSize * dateScale * 1.2, 0)
                    yearNode.eulerAngles = rotationForDate(WWDCDate(month: 0, year: year)) + SCNVector3(0, -M_PI / 4, 0)
                    yearNode.scale = dateScaleVector
                    datesNode.addChildNode(yearNode)
                }
            } catch {
                print(" Could not copy date base for year. \(error)")
            }
            
            for month in (year == startDate.year ? startDate.month : 0)...(year == endDate.year ? endDate.month : 11) {
                // Generate the month node
                let monthNode = SCNNode(geometry: monthGeometries[month])
                monthNode.position = positionForDate(WWDCDate(month: month, year: year))
                monthNode.eulerAngles = rotationForDate(WWDCDate(month: month, year: year))
                monthNode.scale = dateScaleVector
                datesNode.addChildNode(monthNode)
            }
        }
    }
    
    // MARK: Events and markers
    let timelineItemsNode: SCNNode
    let timelineItems: [WWDCTimelineItem]
    
    private func generateItems() {
        // Keep track of previous dates
        var previousDate = WWDCDate(absoluteMonth: 0)
        var previousDateCount = 0
        
        // Generate the items
        for item in timelineItems {
            // Set base positions
            item.basePosition = positionForDate(item.date)
            item.baseAngles = rotationForDate(item.date)
            
            // Register duplicate dates if an event
            if let event = item as? WWDCEvent {
                if event.date == previousDate { // Is a duplicate date, offset position and add to counter
                    previousDateCount += 1
                    event.duplicateDatesBefore = previousDateCount
                } else { // Not a duplicate date, reset counter
                    previousDate = event.date
                    previousDateCount = 0
                }
            }
            
            // Add the node
            timelineItemsNode.addChildNode(item)
        }
    }
    
    // MARK: Positioning
    func splineTimeForDate(date: WWDCDate) -> CGFloat {
        return CGFloat(date.absoluteMonth - startDate.absoluteMonth) / CGFloat(endDate.absoluteMonth - startDate.absoluteMonth)
    }
    
    func positionForTime(t: CGFloat) -> SCNVector3 {
        return timelineSpline.evalutate(time: t)
    }
    
    func positionForDate(date: WWDCDate) -> SCNVector3 {
        return positionForTime(splineTimeForDate(date))
    }
    
    func rotationForTime(t: CGFloat) -> SCNVector3 {
        return timelineSpline.evaluateRotation(time: t, axis: .Y) + SCNVector3(0, CGFloat.pi, 0)
    }
    
    func rotationForDate(date: WWDCDate) -> SCNVector3 {
        return rotationForTime(splineTimeForDate(date))
    }
}