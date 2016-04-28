//
//  WWDCImage.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/26/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

#if os(iOS)
import UIKit
typealias WWDCImage = UIImage
#elseif os(OSX)
import AppKit
typealias WWDCImage = NSImage
#endif