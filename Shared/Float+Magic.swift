//
//  Float+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/30/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import Foundation

extension Float {
    static let zero = 0
    static let pi = Float(M_PI)
    
    static func random() -> Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }
    
    // Linearly interpolates between to values
    static func lerp(start: Float, end: Float, interpolation: Float) -> Float {
        return start * (1 - interpolation) + end * interpolation
    }
    
    // Spherically interpolates between two angles (radians)
    static func slerp(start: Float, end: Float, interpolation: Float) -> Float {
        let cs = (1 - interpolation) * cos(start) + interpolation * cos(end)
        let sn = (1 - interpolation) * sin(start) + interpolation * sin(end)
        return atan2(sn, cs)
    }
}

