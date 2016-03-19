//
//  Pirata.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import Foundation

class Pirata: CCNode {

    private var vida:Int = 3
    private var speed:Double = 3
    private var pontos:Int = 3
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    private var alive:Bool = true
    private var score:Int = 0
    private var spritePirata:CCSprite?
    private var pirata:Int = 0
    private var animationPirate:CCActionAnimate?
    
    convenience init(event:Selector, target:AnyObject, score:Int) {
        self.init()
        self.eventSelector = event
        self.targetID = target
        self.score = score
        let valor = Int(arc4random_uniform(100) + 1)
        let valorDificuldade:Int = self.score / 50
        self.speed = self.speed - (Double(valorDificuldade) * 0.2)
        if(valor > 70){
            pirata = 2
        }
        else{
            pirata = 1
        }
        if(pirata == 1){
            self.spritePirata = self.gerarAnimacaoSpriteWithName("Pirata 1", aQtdFrames: 18)
            if(self.speed < 1){
                self.speed = 1
            }
        }
        else{
            self.spritePirata = self.gerarAnimacaoSpriteWithName("Pirata 2", aQtdFrames: 18)
            vida = 7
            speed = 6
            self.speed = self.speed - (Double(valorDificuldade) * 0.2)
            if(self.speed < 2){
                self.speed = 2
            }
            pontos = 7
        }
   
        
        
        
        spritePirata!.runAction(CCActionRepeatForever(action: self.animationPirate))
        
        self.spritePirata!.position = CGPointMake(0, 0)
        self.spritePirata!.anchorPoint = CGPointMake(0.5, 0.5)
        self.contentSize = self.spritePirata!.boundingBox().size
//        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.spritePirata!.boundingBox().width - 10, self.spritePirata!.boundingBox().height - 10), cornerRadius: 0.0)
//        self.physicsBody.type = CCPhysicsBodyType.Kinematic
////        self.physicsBody.friction = 1.0
////        self.physicsBody.elasticity = 0.1
////        self.physicsBody.mass = 100.0
////        self.physicsBody.density = 100.0
//        self.physicsBody.collisionType = "pirata"
//        self.physicsBody.collisionCategories = ["pirata"]
//        self.physicsBody.collisionMask = ["tiro"]
        self.addChild(spritePirata, z:1)
    }
    func getBoundingBox() -> CGRect {
        return self.spritePirata!.boundingBox()
    }
    func tomaDano(forca:Int) -> Int{
        vida -= forca
        if(vida <= 0){
            self.alive = false
            var splash:CCParticleSystem = CCParticleExplosion(totalParticles: 10)
            splash.texture = CCSprite.spriteWithImageNamed("fire.png").texture
            splash.position = self.position
            splash.anchorPoint = CGPointMake(0.5 ,0.5)
            splash.autoRemoveOnFinish = true
            self.parent!.addChild(splash, z: 2)
            OALSimpleAudio.sharedInstance().playEffect("SoundFXPuf.mp3")
            
            self.stopAllSpriteActions()            
            self.removeFromParentAndCleanup(true)
            return pontos
        }
        return 0
    }
    func stopAllSpriteActions(){
        self.spritePirata!.stopAllActions()
        self.stopAllActions()
    }
    func moveMe(){
        self.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(CCTime(speed*2), position: CGPointMake(-15.0,
            self.position.y)) as! CCActionFiniteTime,
            two: CCActionCallBlock.actionWithBlock({ _ in
                DelayHelper.sharedInstance.callFunc(self.eventSelector!, onTarget: self.targetID!, withDelay: 0.0)
                self.stopAllSpriteActions()
                self.removeFromParentAndCleanup(true)}) as! CCActionFiniteTime)as! CCAction)
    }
    func gerarAnimacaoSpriteWithName(aSpriteName:String,aQtdFrames:Int) -> CCSprite {
        // Carrega os frames da animacao dentro do arquivo passadodada a quantidade de frames
        var animFrames:Array<CCSpriteFrame> = Array()
        var name:String = ""
        for (var i = 1; i <= aQtdFrames; i++) {
            if(i<10){
                name =  "\(aSpriteName)000\(i).png"
                
            }
            else{
                name = "\(aSpriteName)00\(i).png"
            }
            animFrames.append(CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName(name))
            
        }
        // Cria a animacao dos frames montados
        let animation:CCAnimation = CCAnimation(spriteFrames:
            animFrames, delay: 0.02)
        // Cria a acao com a animacao dos frames
        animationPirate = CCActionAnimate(animation: animation)
        // Monta o sprite com o primeiro quadro
        var spriteRet:CCSprite = CCSprite(imageNamed: "\(aSpriteName)0001.png")
        // Retorna o sprite para controle na classe
        return spriteRet
    }
    
}