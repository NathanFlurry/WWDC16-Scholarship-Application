//
//  WWDCColor.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/19/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

#if os(iOS)
typealias WWDCColor = UIColor
#elseif os(OSX)
typealias WWDCColor = NSColor
#endif