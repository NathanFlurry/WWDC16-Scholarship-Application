//
//  WWDCTimingFunctions+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/24/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

extension SCNActionTimingMode {
    static func ease(method method: WWDCTimingMethod, mode: WWDCTimingMode) -> SCNActionTimingFunction {
        let timingFunc = WWDCTimingFunctions.ease(method, mode: mode)
        return {
            (t) in
            return Float(timingFunc(t: Double(t), b: 0, c: 1, d: 1))
        }
    }
}