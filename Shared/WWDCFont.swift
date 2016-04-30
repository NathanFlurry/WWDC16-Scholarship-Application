//
//  WWDCFont.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

#if os(iOS)
typealias WWDCFont = UIFont
#elseif os(OSX)
typealias WWDCFont = NSFont
#endif