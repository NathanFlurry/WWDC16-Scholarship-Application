//
//  NSObject+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/25/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import Foundation

protocol ArchiveCopy : class {
    
}

extension ArchiveCopy {
    func archiveCopy() throws -> Self {
        // KIDS DO NOT DO THIS AT HOME
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        if let newText = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Self {
            return newText
        } else {
            throw NSError(
                domain: "ArchiveCopy",
                code: 0, 
                userInfo: [ "message": "Something went terribly wrong doing something terribly bad (aka copying with the NSKeyedArchiver)."]
            )
        }
    }
}

extension NSObject: ArchiveCopy {
    
}