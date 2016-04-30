//
//  WWDCImage.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/26/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

#if os(iOS)
typealias WWDCImage = UIImage
#elseif os(OSX)
typealias WWDCImage = NSImage
#endif