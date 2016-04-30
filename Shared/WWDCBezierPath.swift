//
//  WWDCBezierPath.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/30/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

#if os(iOS)
typealias WWDCBezierPath = UIBezierPath
#elseif os(OSX)
typealias WWDCBezierPath = NSBezierPath
#endif