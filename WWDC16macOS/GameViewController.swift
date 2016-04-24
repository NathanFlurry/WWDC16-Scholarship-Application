//
//  GameViewController.swift
//  WWDC16macOS
//
//  Created by Nathan Flurry on 4/18/16.
//  Copyright (c) 2016 Nathan Flurry. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        gameView.configureForWWDC()
    }

}
