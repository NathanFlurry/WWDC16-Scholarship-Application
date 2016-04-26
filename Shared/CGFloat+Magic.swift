//
//  CGFloat+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static let zero = 0
    static let pi = CGFloat(M_PI)
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
    
    // Linearly interpolates between to values
    static func lerp(start: CGFloat, end: CGFloat, interpolation: CGFloat) -> CGFloat {
        return start * (1 - interpolation) + end * interpolation
    }
    
    // Spherically interpolates between two angles (radians)
    static func slerp(start: CGFloat, end: CGFloat, interpolation: CGFloat) -> CGFloat {
        let cs = (1 - interpolation) * cos(start) + interpolation * cos(end)
        let sn = (1 - interpolation) * sin(start) + interpolation * sin(end)
        return atan2(sn, cs)
    }
}

