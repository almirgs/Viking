//
//  Tiro.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import Foundation

class Tiro: CCNode {
    
    private var vida:Int = 3
    private var speed:Double = 2
    private var pontos:Int = 3
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    private var spriteTiro:CCSprite?
    private var pontoClick:CGPoint?
    private var pontoViking:CGPoint?
    
    convenience init(
        //event:Selector, target:AnyObject, 
        click:CGPoint, viking:CGPoint) {
        self.init()
//        self.eventSelector = event
//        self.targetID = target
        self.pontoClick = click
        self.pontoViking = viking
        self.spriteTiro = CCSprite(imageNamed: "tiro-ipad.png")
        
        self.spriteTiro!.position = CGPointMake(0, 0)
        self.spriteTiro!.anchorPoint = CGPointMake(0.5, 0.5)
        self.contentSize = self.spriteTiro!.boundingBox().size
//            self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.spriteTiro!.boundingBox().width - 10, self.spriteTiro!.boundingBox().height - 10), cornerRadius: 0.0)
//            self.physicsBody.type = CCPhysicsBodyType.Kinematic
//            self.physicsBody.collisionType = "tiro"
//            self.physicsBody.collisionCategories = ["tiro"]
//            self.physicsBody.collisionMask = ["pirata"]
        self.addChild(spriteTiro, z:1)
    }
    func getBoundingBox() -> CGRect{
        return self.spriteTiro!.boundingBox()
    }
    func stopAllSpriteActions(){
        self.spriteTiro!.stopAllActions()
        self.stopAllActions()
    }
    func moveMe(){
        self.runAction(CCActionRepeatForever(action: CCActionRotateBy(duration: 1, angle: 360)))
        let pos:CGPoint = calculaPontoFinal()
        self.runAction(CCActionSequence.actionOne(CCActionMoveTo(duration: CCTime(self.speed), position: pos) as! CCActionFiniteTime,
            two: CCActionCallBlock.actionWithBlock({ _ in
                self.stopAllSpriteActions()
                self.removeFromParentAndCleanup(true)}) as! CCActionFiniteTime)as! CCAction
            )
        
    }
    func calculaPontoFinal() -> CGPoint{
        let angulo:CGFloat = (pontoClick!.y - pontoViking!.y ) / pontoClick!.x
        var pontoX:CGFloat = 0.0
        var pontoY:CGFloat = 0.0
        if(angulo > 0){
            pontoX = (768.0 - pontoViking!.y) / angulo
            pontoY = ((pontoX*angulo) + pontoViking!.y)
        }
        else if(angulo == 0.0){
            pontoX = 1024.0
            pontoY = pontoViking!.y
        }
        else if(angulo < 0){
            pontoX = ( 0 - pontoViking!.y) / angulo
            pontoY = ((pontoX*angulo) + pontoViking!.y)
        }
        self.speed = Double(pontoX) / 500
        
        return CGPointMake(pontoX, pontoY)
    }
    override func update(delta: CCTime) {
//        if(self.spriteTiro!.position.x > 1030 || self.spriteTiro!.position.y > 780){
//            self.stopAllSpriteActions()
//            self.spriteTiro?.removeFromParentAndCleanup(true)
//        }
    }
}