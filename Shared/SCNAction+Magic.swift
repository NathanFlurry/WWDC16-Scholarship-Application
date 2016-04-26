//
//  SCNAction+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/24/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

extension SCNAction {
    static func customActionWithDuration(seconds duration: NSTimeInterval, method: WWDCTimingMethod, mode: WWDCTimingMode, actionBlock: (SCNNode, CGFloat) -> Void) -> SCNAction {
        // Time in action block is between 0 and 1
        let timingFunc = SCNActionTimingMode.ease(method: method, mode: mode)
        return self.customActionWithDuration(duration) {
            (node, time) in
            actionBlock( node, CGFloat( timingFunc( Float(time) / Float(duration) ) ) )
        }
    }
}