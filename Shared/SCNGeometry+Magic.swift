//
//  SCNGeometry+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/25/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import AppKit

let straightChamferProfile = {
    () -> NSBezierPath in
    var path = NSBezierPath()
    path.moveToPoint(NSPoint(x: 0, y: 1))
    path.lineToPoint(NSPoint(x: 1, y: 0))
    return path
}()