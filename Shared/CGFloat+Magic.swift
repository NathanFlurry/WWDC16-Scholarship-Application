//
//  CGFloat+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static let pi = CGFloat(M_PI)
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
}

