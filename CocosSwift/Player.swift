//
//  Player.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import Foundation

class Player: CCNode {
    private var vida:Int = 3
    private var forca:Int = 1
    private var alive:Bool = true
    private var spritePlayer:CCSprite?
    internal var event:Selector?
    internal var targetID:AnyObject?
    
    convenience init(event:Selector, targetID:AnyObject) {
        self.init()
        self.event = event
        self.targetID = targetID
        self.spritePlayer = CCSprite(imageNamed:"player-ipad.png")

        self.spritePlayer!.position = CGPointMake(0, 0)
        self.spritePlayer!.anchorPoint = CGPointMake(0.0, 0.0)
        self.contentSize = self.spritePlayer!.boundingBox().size
        self.addChild(spritePlayer, z:1) 
    }
    func levaDano(){
        vida -= 1
    }
    func getVida() -> Int{
        return vida
    }
    func getForca() -> Int{
        return self.forca
    }
    func pwrUpForca(){
        forca *= 3
        spritePlayer!.color = CCColor.redColor()
    }
    func pwrUpForcaAcaba(){
        forca /= 3
         spritePlayer!.color = CCColor(red: 1, green: 1, blue: 1)
        DelayHelper.sharedInstance.callFunc(event!, onTarget: targetID!, withDelay: 0.0)
    }
}