//
//  WWDCColor.swift
//  WWDC16iOS
//
//  Created by Nathan Flurry on 4/19/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

//protocol WWDCColorProtocol {
//    var r: Float { get set }
//    var g: Float { get set }
//    var b: Float { get set }
//    var a: Float { get set }
//    
//    init?(CGColor cgColor: CGColor)
////    init(r: Float, g: Float, b: Float, a: Float)
//}
//
//#if os(iOS)
//class WWDCColor : UIColor, WWDCColorProtocol {
//    
//}
//#elseif os(OSX)
//class WWDCColor : NSColor, WWDCColorProtocol {
//    var r: Float = 0
//    var g: Float = 0
//    var b: Float = 0
//    var a: Float = 0
//    
//    init?(CGColor cgColor: CGColor) {
//        
//    }
//    
//    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
//        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    required init?(pasteboardPropertyList propertyList: AnyObject, ofType type: String) {
//        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
//    }
//}
//#endif

import SceneKit

#if os(iOS)
typealias WWDCColor = UIColor
#elseif os(OSX)
typealias WWDCColor = NSColor
#endif