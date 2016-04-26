//
//  CollectionType+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/25/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import Foundation

extension CollectionType {
    // Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}