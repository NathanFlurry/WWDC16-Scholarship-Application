//
//  WWDCPoint.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/30/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

// Handy for briding bezier curve code
#if os(iOS)
typealias WWDCPoint = CGPoint
#elseif os(OSX)
typealias WWDCPoint = NSPoint
#endif