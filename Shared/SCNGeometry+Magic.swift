//
//  SCNGeometry+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/25/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

let straightChamferProfile = {
    () -> WWDCBezierPath in
    var path = WWDCBezierPath()
    path.moveToPoint(WWDCPoint(x: 0, y: 1))
    #if os(iOS)
    path.addLineToPoint(WWDCPoint(x: 1, y: 0))
    #elseif os(OSX)
    path.lineToPoint(WWDCPoint(x: 1, y: 0))
    #endif
    return path
}()