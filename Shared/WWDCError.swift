//
//  WWDCError.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/21/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import Foundation

class WWDCError : ErrorType, CustomStringConvertible, CustomDebugStringConvertible {
    let message: String
    let attatchedError: ErrorType?
    
    var description: String {
        return "\(message)"
    }
    
    var debugDescription: String {
        return "\(message)"
    }
    
    init(message: String, attatchedError: ErrorType?) {
        self.message = message
        self.attatchedError = attatchedError
    }
    
    convenience init(message: String) {
        self.init(message: message, attatchedError: nil)
    }
}