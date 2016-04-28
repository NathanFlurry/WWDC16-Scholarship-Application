//
//  SCNNode+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/27/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

extension SCNNode {
    func center() {
        var v1 = SCNVector3()
        var v2 = SCNVector3()
        getBoundingBoxMin(&v1, max: &v2)
        position = position - (v2 - v1) / 2
    }
}