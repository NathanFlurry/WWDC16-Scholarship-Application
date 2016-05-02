//
//  WWDCMainScene.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/18/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

/*
 Notes for readers:
 - This was all programmed from beginning to finish in one and a half weeks
 - This was inspired by the WWDC '14 SceneKit session, in case it looks mildly familiar
 - There's an odd issue where there's black bars around some of the videos – I spend quite a long time trying to debug this, but I didn't have any luck. I'll be posting a bug report soon.
 - I have never used SceneKit (only SpriteKit, both of which are amazing) before beginning this project
 - Let's just say that writting proper Git commit changelogs was *not* my top priority ;)
 - Enjoy the protocol spaghetti with my hacks for getting SCNVector3 to work across platforms
 - Finally, I appreciate you considering my application for a scholarship
 */

class WWDCMainScene : SCNScene {
    static var singleton: WWDCMainScene?
    
    let view: SCNView
    
    let bgColor = WWDCColors.charade
    
    private var currentSlide: Int = -1
    var slide: Int {
        return currentSlide
    }
    
    let camera: WWDCCamera
    
    let floor: WWDCFloor
    let timeline: WWDCTimeline
    
    var lights = [SCNNode]()
    
    init(sceneView: SCNView) {
        // Save the view
        self.view = sceneView
        
        // Create the floor
        floor = WWDCFloor()
        
        // Create the dates
        do {
            timeline = WWDCTimeline(
                timelineItems: [
                    try WWDCMarker(date: WWDCDate(properMonth: 6, year: 2016), sceneName: "AppleTV"),
                    try WWDCMarker(date: WWDCDate(properMonth: 8, year: 2016), sceneName: "iPhone"),
                    try WWDCMarker(date: WWDCDate(properMonth: 5, year: 2016), sceneName: "MacBookPro"),
                    try WWDCMarker(date: WWDCDate(properMonth: 6, year: 2015), sceneName: "iPad"),
                    try WWDCMarker(date: WWDCDate(properMonth: 5, year: 2014), sceneName: "MacMini"),
                    try WWDCMarker(date: WWDCDate(properMonth: 1, year: 2014), sceneName: "iPodTouch"),
                    try WWDCMarker(date: WWDCDate(properMonth: 9, year: 2013), sceneName: "eMac"),
                    
                    WWDCEvent(
                        date: WWDCDate(properMonth: 10, year: 2016),
                        title: "",
                        text: "",
                        customHandler: WWDCEndScreenHandler()
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 8, year: 2016),
                        title: "ANN Project",
                        text: "As my elective for school next year, I will be doing a research project on artificial neural networking (ANN). This will consist of doing research, creating a product, and writing a thesis on it."
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 8, year: 2016),
                        title: "Programming Club",
                        text: "Next year, I will be hosting a programming club in order to teach students computer science principles in Swift."
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 5, year: 2016),
                        endDate: WWDCDate(properMonth: 7, year: 2016),
                        title: "Wiblits Internship",
                        text: "This summer, I will be living in Phoenix for two months to work with a team on Wiblits – an app that allows players to compete in quick, fun micro-games with their friends and others. I will be working on both the backend and the iOS client."
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 8, year: 2015),
                        endDate: WWDCDate(properMonth: 5, year: 2016),
                        title: "Aroid (WIP)",
                        text: "Aroid is a multiplayer game where players use their spaceships to battle each other in space  — essentially a modernized, multiplayer version of the original arcade game, Asteroids. So far, the game has thirty-two uniquely different ships, seven weapons, twelve special abilities, seven game modes, and much more. The game is set to be released late this summer.",
                        media: .Video("Aroid", "mp4")
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 7, year: 2015),
                        title: "Chomp",
                        text: "Chomp was a game developed for the forty-eight hour game development competition, Ludum Dare. In the game's cartoon post-apocalyptic world, the player is tasked with the duty of feeding hungry monsters. To do this, the player must launch whimsical carcasses into the air and into the monsters' mouths for them to gobble up. The entry was peer-ranked within the top 20% among thousands of other entries.",
                        media: .Video("Chomp", "mp4")
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 7, year: 2015),
                        title: "GrainTracker",
                        text: "Grain Tracker was an iOS inventory application for food banks developed in thirty-six hours for the first Great Arizona <Code> Challenge. The application included the ability to quickly and easily add items to the inventory by scanning the barcode with the phone's camera, fetch the nutrition information of an item from the web automatically, and instantly provide photos of the products from Google Images inline. This project was awarded second place.",
                        media: .Image("GrainTracker", "png")
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 5, year: 2015),
                        endDate: WWDCDate(properMonth: 8, year: 2015),
                        title: "Jubel",
                        text: "Jubel is a prototype for a consumer-friendly shopping platform that combines the social aspect of shopping with the convenience of online shopping. I did not have the time nor money to complete the project to the extend I wished, so I put the undertaking on hold.",
                        media: .Video("Jubel", "mp4")
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 12, year: 2014),
                        title: "CatchPhrase",
                        text: "As a short project completed in five days, I developed a small CatchPhrase clone. In the game, players can each have their own individual mobile device and all play together. The goal of the game is to have one player on each team attempt to describe a word or phrase without using the word itself.",
                        media: .Video("CatchPhrase", "mp4")
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 4, year: 2014),
                        endDate: WWDCDate(properMonth: 4, year: 2015),
                        title: "LaughItUp",
                        text: "As a project to get aquatinted with full-stack development, LaughItUp was a social network concept I developed that allowed users to consume and provide humorous content. While the project did gain some traction, I decided it did not have the market available to make it worthwhile to polish and release the app.",
                        media: .Video("LaughItUp", "mp4")
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 12, year: 2013),
                        title: "KickAsteroids",
                        text: "Developed for the Winter Codea Holiday Cook Off competition, I developed a game called KickAsteroids. The goal of the game is to defend your planet by dragging your finger around the screen to shatter the retro-looking asteroids. This game was awarded second place in the competition.",
                        media: .Video("KickAsteroids", "mp4")
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 12, year: 2013),
                        title: "SnakeChase",
                        text: "For a Ludum Dare forty-eight hour competition, I developed a game called SnakeChase. Playing as a snake, the player's goal is to navigate around an infinite, procedurally generated world collecting as many moving blobs as possible. Each time the player eats a blob, the snake becomes longer. When one of these moving blobs touches the side of the player, the the snake is cut off at the point of impact and the player loses a \"life.\""
                    ),
                    WWDCEvent(
                        date: WWDCDate(properMonth: 10, year: 2013),
                        title: "StackIt",
                        text: "In the game StackIt, the player's goal is to move and tilt a paddle in order to balance objects falling from the sky while not letting them fall off the paddle into oblivion. The game features a dynamic background which reflects the current weather, moon phase, time of day, and special themes for holidays. The game ended up receiving tens of thousand of downloads in total.",
                        media: .Video("StackIt", "mp4")
                    ),
                    WWDCEvent( // Starter slide
                        date: WWDCDate(properMonth: 9, year: 2013),
                        title: "",
                        text: "",
                        customHandler: WWDCStartScreenHandler()
                    ),
                ],
                timelineSpline: WWDCSpline(
                    points: {
                        () -> [SCNVector3] in
                        var arr = [SCNVector3]()
                        for i in 0...8 {
                            arr += [ SCNVector3(VFloat.random() * 200 - 100, 0, -VFloat(i) * 75) ]
                        }
                        return arr
                    }(),
                    method: .Cubic
                )
            )
        } catch {
            print("Could not create timeline. \(error)")
            timeline = WWDCTimeline(timelineItems: [], timelineSpline: WWDCSpline(points: [], method: .Linear))
        }
 
        // Create the camera
        camera = WWDCCamera()
 
        super.init()
        
        // Set the singleon
        WWDCMainScene.singleton = self
        
        // Add the fog
        fogColor = WWDCColor.blackColor()
        fogStartDistance = 15
        fogEndDistance = 50
//        fogDensityExponent = 0.5
        fogColor = bgColor
        
        // Add the lights
        addLights()
        
        // Add the nodes
        rootNode.addChildNode(floor)
        rootNode.addChildNode(timeline)
        
        // Add the camera
        rootNode.addChildNode(camera)
        camera.positionOffset = SCNVector3(0, 5, 50) // Set initial position of camera
        transitionToIndex(0) // Move to first slide
        sceneView.pointOfView = camera // Activate the camera
    }
    
    func addLights() {
        // Front light
//        let front = SCNNode()
//        front.name = "Front"
//        front.eulerAngles = SCNVector3(CGFloat.pi  * 0.1, 0, 0)
//        front.light = SCNLight()
//        front.light?.type = SCNLightTypeDirectional
//        front.light?.color = WWDCColor.lightGrayColor()
//        camera.addChildNode(front)
        
        // Spot light
        let spot = SCNNode()
        spot.name = "Spot"
        spot.position = SCNVector3(15, 30, -7) // Slightly offset to make the shadows not look perfect
        spot.light = SCNLight()
        spot.light?.type = SCNLightTypeSpot
        spot.light?.shadowRadius = 3
        spot.light?.zNear = 20
        spot.light?.zFar = 100
        spot.light?.castsShadow = true
        spot.light?.color = WWDCColor.lightGrayColor()
        let lookConstraint = SCNLookAtConstraint(target: camera.focus)
        spot.constraints = [ lookConstraint ]
        camera.addChildNode(spot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Dates
    private let dateSpacing: Float = 3
    private let dateSize: Float = 3
    
    func transitionToIndex(index: Int) {
        // Check the index is in range
        guard index < timeline.events.count && index >= 0 else {
//            print("Slide index \(index) out of range.")
            return
        }
        
        // Get the events
        let nextEvent = timeline.events[index]
        let previousEvent = timeline.events[safe: currentSlide] // Previous slide may not exist
        
        // Define the animation parameters
        let method = WWDCTimingMethod.Quadratic
        let mode = WWDCTimingMode.EaseInOut
        var duration: NSTimeInterval = 1.8
        var eventDuration: NSTimeInterval = 1.0
        
        // Change animation parameters if not moving the camera
        if let prev = previousEvent where prev.date == nextEvent.date {
            duration = 0.6
            eventDuration = duration
        }
        
        // Transition the camera to the event
        camera.transitionToEvent(nextEvent, duration: duration, method: method, mode: mode)
        
        // Transition the events
        previousEvent?.fadeOut(duration, method: method, mode: mode)
        nextEvent.fadeIn(duration - eventDuration, duration: eventDuration, method: method, mode: mode)
        
        // Save the index
        currentSlide = index
    }
    
    func nextSlide() {
        transitionToIndex(slide + 1)
    }
    
    func previousSlide() {
        transitionToIndex(slide - 1)
    }
    
//    private func testSpline() {
//        let spline = WWDCSpline(points: [
//                SCNVector3(0,0,0),
//                SCNVector3(5,5,0),
//                SCNVector3(10,0,0),
//                SCNVector3(15,5,0),
//                SCNVector3(10,10,0),
//                SCNVector3(5,15,0),
//                SCNVector3(0,10,0)
//            ]
//        )
//
//        let b = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        var t: CGFloat = 0.0
//        while t <= 1 {
//            let n = SCNNode(geometry: b)
//            n.position = spline.evalutate(time: t, method: .Cubic)
//            rootNode.addChildNode(n)
//            t += 0.01
//        }
//
//        let bb = SCNSphere(radius: 0.2)
//        for p in spline.points {
//            let n = SCNNode(geometry: bb)
//            n.position = p
//            rootNode.addChildNode(n)
//        }
//    }
    
//    private func testDisplayPanel() {
////        let geometry = WWDCDisplayPanel(contents: .Image("TestImage"), size: 5)
//        let geometry = WWDCDisplayPanel(contents: .Video("LaughItUp", "mp4"), size: 5)
//        
//        let node = SCNNode(geometry: geometry)
//        node.position = SCNVector3(0, 300, 0)
//        let s = 1 / timeline.events[0].slideScale
//        node.scale = SCNVector3(s, s, s)
//        timeline.events[0].addChildNode(node)
//    }
}