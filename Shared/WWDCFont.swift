//
//  WWDCFont.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

#if os(iOS)
import UIKit
typealias Font = UIFont
#elseif os(OSX)
import AppKit
typealias Font = NSFont
#endif