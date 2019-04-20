//
//  GameView.swift
//  SceneKitVehicle
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/17.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  A SceneKit view that handles touch events.

 */

import UIKit
import SceneKit
import SpriteKit

@objc(AAPLGameView)
class GameView: SCNView {
    
    var touchCount: Int = 0
    var inCarView: Bool = false
    
    private func changePointOfView() {
        // retrieve the list of point of views
        let pointOfViews = scene!.rootNode.childNodes {child, stop in
            return child.camera != nil
            }
        
        let currentPointOfView = self.pointOfView
        
        // select the next one
        var index = pointOfViews.firstIndex(of: currentPointOfView!) ?? 0
        index += 1
        if index >= pointOfViews.count {
            index = 0
        }
        
        inCarView = (index == 0)
        
        // set it with an implicit transaction
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.75
        self.pointOfView = pointOfViews[index]
        SCNTransaction.commit()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        //test if we hit the camera button
        let scene = overlaySKScene
        var p = touch.location(in: self)
        p = scene!.convertPoint(fromView: p)
        let node = scene!.atPoint(p)
        
        if node.name != nil && node.name == "camera" {
            //play a sound
            node.run(SKAction.playSoundFileNamed("click.caf", waitForCompletion: false))
            //change the point of view
            changePointOfView()
            return
        }
        
        //update the total number of touches on screen
        let allTouches = event!.allTouches
        touchCount = allTouches!.count
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchCount = 0
    }
    
}
