//
//  WWDCTimingFunctions.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/24/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import Foundation

// t - current time, b - start value, c - change in value, d - duration
typealias WWDCTimingFunction = (t: Double, b: Double, c: Double, d: Double) -> Double

enum WWDCTimingMethod {
    case Linear, Quadratic, Cubic, Quartic, Quintic, Sinusoidal, Exponential, Circular
}

enum WWDCTimingMode {
    case EaseIn, EaseOut, EaseInOut
}

class WWDCTimingFunctions { // See http://gizma.com/easing/
    // MARK: Linear
    static let linear: WWDCTimingFunction = {
        (t, b, c, d) in
        return c * t / d + b
    }
    
    // MARK: Quadratic
    static let easeInQuad: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d
        return c * t * t + b
    }
    
    static let easeOutQuad: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d
        return -c * t * (t - 2) + b
    }
    
    static let easeInOutQuad: WWDCTimingFunction = {
        (tt, b, c, d) in
        var t = tt / (d / 2)
        if t < 1 {
            return c / 2 * t * t + b
        } else {
            t -= 1
            return -c / 2 * (t * (t - 2) - 1) + b
        }
    }
    
    // MARK: Cubic
    static let easeInCubic: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d
        return c * t * t * t + b
    }
    
    static let easeOutCubic: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d - 1
        return c * (t * t * t + 1) + b
    }
    
    static let easeInOutCubic: WWDCTimingFunction = {
        (tt, b, c, d) in
        var t = tt / (d / 2)
        if t < 1 {
            return c / 2 * t * t * t + b
        } else {
            t -= 2
            return c / 2 * (t * t * t + 2) + b
        }
    }
    
    // MARK: Quartic
    static let easeInQuart: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d
        return c * t * t * t * t + b
    }
    
    static let easeOutQuart: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d - 1
        return -c * (t * t * t * t - 1) + b
    }
    
    static let easeInOutQuart: WWDCTimingFunction = {
        (tt, b, c, d) in
        var t = tt / (d / 2)
        if t < 1 {
            return c / 2 * t * t * t * t + b
        } else {
            t -= 2
            return -c / 2 * (t * t * t * t - 2) + b
        }
    }
    
    // MARK: Quintic
    static let easeInQuint: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d
        return c * t * t * t * t * t + b
    }
    
    static let easeOutQuint: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d - 1
        return c * (t * t * t * t * t + 1) + b
    }
    
    static let easeInOutQuint: WWDCTimingFunction = {
        (tt, b, c, d) in
        var t = tt / (d / 2)
        if t < 1 {
            return c / 2 * t * t * t * t * t + b
        } else {
            t -= 2
            return c / 2 * (t * t * t * t * t + 2) + b
        }
    }
    
    // MARK: Sinusoidal
    static let easeInSin: WWDCTimingFunction = {
        (t, b, c, d) in
        return -c * cos(t / d * M_PI_2) + c + b
    }
    
    static let easeOutSin: WWDCTimingFunction = {
        (t, b, c, d) in
        return c * sin(t / d * M_PI_2) + b
    }
    
    static let easeInOutSin: WWDCTimingFunction = {
        (t, b, c, d) in
        return -c / 2 * (cos(M_PI * t / d) - 1) + b
    }
    
    // MARK: Exponential
    static let easeInExpo: WWDCTimingFunction = {
        (t, b, c, d) in
        return c * pow(2, 10 * (t / d - 1)) + b
    }
    
    static let easeOutExpo: WWDCTimingFunction = {
        (t, b, c, d) in
        return c * (-pow(2, -10 * t / d ) + 1 ) + b
    }
    
    static let easeInOutExpo: WWDCTimingFunction = {
        (tt, b, c, d) in
        var t = tt / (d / 2)
        if t < 1 {
            return c / 2 * pow(2, 10 * (t - 1)) + b
        } else {
            t -= 1
            return c / 2 * (-pow(2, -10 * t) + 2) + b
        }
    }
    
    // MARK: Circular
    static let easeInCirc: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d
        return -c * (sqrt(1 - t * t) - 1) + b
    }
    
    static let easeOutCirc: WWDCTimingFunction = {
        (tt, b, c, d) in
        let t = tt / d - 1
        return c * sqrt(1 - t * t) + b
    }
    
    static let easeInOutCirc: WWDCTimingFunction = {
        (tt, b, c, d) in
        var t = tt / (d / 2)
        if t < 1 {
            return -c / 2 * (sqrt(1 - t * t) - 1) + b
        } else {
            t -= 2
            return c / 2 * (sqrt(1 - t * t) + 1) + b
        }
    }
    
    // MARK: Combined
    static func ease(method: WWDCTimingMethod, mode: WWDCTimingMode) -> WWDCTimingFunction {
        switch method {
        case .Linear:
            return WWDCTimingFunctions.linear
        case .Quadratic:
            switch mode {
            case .EaseIn:
                return WWDCTimingFunctions.easeInQuad
            case .EaseOut:
                return WWDCTimingFunctions.easeOutQuad
            case .EaseInOut:
                return WWDCTimingFunctions.easeInOutQuad
            }
        case .Cubic:
            switch mode {
            case .EaseIn:
                return WWDCTimingFunctions.easeInCubic
            case .EaseOut:
                return WWDCTimingFunctions.easeOutCubic
            case .EaseInOut:
                return WWDCTimingFunctions.easeInOutCubic
            }
        case .Quartic:
            switch mode {
            case .EaseIn:
                return WWDCTimingFunctions.easeInQuart
            case .EaseOut:
                return WWDCTimingFunctions.easeOutQuart
            case .EaseInOut:
                return WWDCTimingFunctions.easeInOutQuart
            }
        case .Quintic:
            switch mode {
            case .EaseIn:
                return WWDCTimingFunctions.easeInQuint
            case .EaseOut:
                return WWDCTimingFunctions.easeOutQuint
            case .EaseInOut:
                return WWDCTimingFunctions.easeInOutQuint
            }
        case .Sinusoidal:
            switch mode {
            case .EaseIn:
                return WWDCTimingFunctions.easeInSin
            case .EaseOut:
                return WWDCTimingFunctions.easeOutSin
            case .EaseInOut:
                return WWDCTimingFunctions.easeInOutSin
            }
        case .Exponential:
            switch mode {
            case .EaseIn:
                return WWDCTimingFunctions.easeInExpo
            case .EaseOut:
                return WWDCTimingFunctions.easeOutExpo
            case .EaseInOut:
                return WWDCTimingFunctions.easeInOutExpo
            }
        case .Circular:
            switch mode {
            case .EaseIn:
                return WWDCTimingFunctions.easeInCirc
            case .EaseOut:
                return WWDCTimingFunctions.easeOutCirc
            case .EaseInOut:
                return WWDCTimingFunctions.easeInOutCirc
            }
        }
    }
    
}