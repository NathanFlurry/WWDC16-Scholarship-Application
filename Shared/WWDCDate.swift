//
//  WWDCDate.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/20/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import Foundation

// MARK: Comparison operators
func < (lhs: WWDCDate, rhs: WWDCDate) -> Bool {
    return lhs.absoluteMonth < rhs.absoluteMonth
}

func <= (lhs: WWDCDate, rhs: WWDCDate) -> Bool {
    return lhs.absoluteMonth <= rhs.absoluteMonth
}

func > (lhs: WWDCDate, rhs: WWDCDate) -> Bool{
    return lhs.absoluteMonth > rhs.absoluteMonth
}

func >= (lhs: WWDCDate, rhs: WWDCDate) -> Bool {
    return lhs.absoluteMonth >= rhs.absoluteMonth
}

func == (lhs: WWDCDate, rhs: WWDCDate) -> Bool {
    return lhs.absoluteMonth == rhs.absoluteMonth
}

// MARK: Math operators
func + (lhs: WWDCDate, rhs: WWDCDate) -> WWDCDate {
    return WWDCDate(absoluteMonth: lhs.absoluteMonth + rhs.absoluteMonth)
}

func + (lhs: WWDCDate, rhs: Int) -> WWDCDate {
    return WWDCDate(absoluteMonth: lhs.absoluteMonth + rhs)
}

func - (lhs: WWDCDate, rhs: WWDCDate) -> WWDCDate {
    return WWDCDate(absoluteMonth: lhs.absoluteMonth - rhs.absoluteMonth)
}

func - (lhs: WWDCDate, rhs: Int) -> WWDCDate {
    return WWDCDate(absoluteMonth: lhs.absoluteMonth - rhs)
}

// MARK: Structure
struct WWDCDate : CustomStringConvertible {
    static let months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
    
    static var min = WWDCDate(month: 0, year: Int.min)
    static var max = WWDCDate(month: 11, year: Int.max)
    
    var month: Int // 0-11
    var year: Int
    
    var description: String {
        return "\(WWDCDate.months[month]) \(year)"
    }
    
    init(month: Int, year: Int) {
        self.month = month % 12
        self.year = year
    }
    
    init(properMonth: Int, year: Int) {
        self.init(month: properMonth - 1, year: year)
    }
    
    init(absoluteMonth: Int) {
        self.init(month: absoluteMonth % 12, year: absoluteMonth / 12)
    }
    
    var absoluteMonth: Int {
        if (year > Int.max / 12 - month) {
            return Int.max
        } else if (year < Int.min / 12 + month) {
            return Int.min
        } else {
            return year * 12 + month
        }
    }
}