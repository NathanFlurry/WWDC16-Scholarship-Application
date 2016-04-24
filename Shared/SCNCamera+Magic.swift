//
//  SCNCamera+Magic.swift
//  WWDC16
//
//  Created by Nathan Flurry on 4/22/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

extension SCNCamera {
    func focusFovOnSize(size: CGSize, distance: CGFloat) {
        /*
         Need multiply angle by 2x since it's the total FOV of the camera
         
         |\
         |o\
         |  \
     dist|   \
         |    \
         |     \
         |______\
          width
         */
        
        let conversionFactor: Double = 180 / M_PI
        xFov = atan2(Double(size.width / 2), Double(distance)) * 2 * conversionFactor
        yFov = atan2(Double(size.height / 2), Double(distance)) * 2 * conversionFactor
    }
}