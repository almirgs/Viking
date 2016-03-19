//
//  Player.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import Foundation

class PowerUp: CCNode {
    private var spritePwrUp:CCSprite?
    internal var eventStart:Selector?
    internal var eventEnd:Selector?
    internal var targetID:AnyObject?
    
    convenience init(eventStart:Selector,eventEnd:Selector, targetID:AnyObject ) {
        self.init()
        self.userInteractionEnabled = true
        self.eventStart = eventStart
        self.eventEnd = eventEnd
        self.targetID = targetID
        self.spritePwrUp = CCSprite(imageNamed:"powerUP-ipad.png")
        
        self.spritePwrUp!.position = CGPointMake(0, 0)
        self.spritePwrUp!.anchorPoint = CGPointMake(0.0, 0.0)
        self.contentSize = self.spritePwrUp!.boundingBox().size
        self.addChild(spritePwrUp, z:1)
    }
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        DelayHelper.sharedInstance.callFunc(eventStart!, onTarget: targetID!, withDelay: 0.0)
        self.stopAllActions()
        self.spritePwrUp!.stopAllActions()
        self.removeFromParentAndCleanup(true)
        DelayHelper.sharedInstance.callFunc(eventEnd!, onTarget: targetID!, withDelay: 10.0)
    }
}