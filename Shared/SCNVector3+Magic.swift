//
//  SCNVector3+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/23/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return lhs + (-rhs)
}

func * (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
}

func * (lhs: SCNVector3, rhs: CGFloat) -> SCNVector3 {
    return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

func / (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x / rhs.x, lhs.y / rhs.y, lhs.z / rhs.z)
}

func / (lhs: SCNVector3, rhs: CGFloat) -> SCNVector3 {
    return SCNVector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
}

prefix func - (vector: SCNVector3) -> SCNVector3 {
    return SCNVector3(-vector.x, -vector.y, -vector.z)
}

func * (quat: SCNQuaternion, vec: SCNVector3) -> SCNVector3 {
    let num = quat.x * 2
    let num2 = quat.y * 2
    let num3 = quat.z * 2
    let num4 = quat.x * num
    let num5 = quat.y * num2
    let num6 = quat.z * num3
    let num7 = quat.x * num2
    let num8 = quat.x * num3
    let num9 = quat.y * num3
    let num10 = quat.w * num
    let num11 = quat.w * num2
    let num12 = quat.w * num3
    let x = (1 - (num5 + num6)) * vec.x + (num7 - num12) * vec.y + (num8 + num11) * vec.z
    let y = (num7 + num12) * vec.x + (1 - (num4 + num6)) * vec.y + (num9 - num10) * vec.z
    let z = (num8 - num11) * vec.x + (num9 + num10) * vec.y + (1 - (num4 + num5)) * vec.z
    return SCNVector3(x, y, z)
}