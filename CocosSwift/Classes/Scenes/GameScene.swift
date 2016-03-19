//
//  GameScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

enum GameSceneEnergiaImages:String {
    case EnergiaVerde = "energiaVerde-ipad.png"
    case EnergiaAmarela = "energiaAmarela-ipad.png"
    case EnergiaVermelha = "energiaVermelha-ipad.png"
}

// MARK: - Class Definition
class GameScene: CCScene, CCPhysicsCollisionDelegate {
	// MARK: - Public Objects
	
	// MARK: - Private Objects
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    private let labelScore:CCLabelTTF = CCLabelTTF(string: "Score: 0", fontName: "Verdana", fontSize: 18.0)
    private let background:CCSprite = CCSprite(imageNamed: "bgCenario-ipad.png")
    private var faixa:CCSprite = CCSprite(imageNamed: GameSceneEnergiaImages.EnergiaVerde.rawValue)
    private let backButton:CCButton = CCButton(title: "[ Quit ]", fontName: "Verdana-Bold", fontSize: 28.0)
    private let pauseButton:CCButton = CCButton(title: "[ Pause ]", fontName: "Verdana-Bold", fontSize: 28.0)
    private let labelGameOver1:CCLabelTTF = CCLabelTTF(string: "_== GAME OVER ==_", fontName: "Verdana", fontSize: 32.0)
    private let labelGameOver2:CCLabelTTF = CCLabelTTF(string: "Tap to restart", fontName: "Verdana", fontSize: 24.0)
    private let labelPaused1:CCLabelTTF = CCLabelTTF(string: "_== PAUSED ==_", fontName: "Verdana", fontSize: 32.0)
    private let labelPaused2:CCLabelTTF = CCLabelTTF(string: "Tap to resume", fontName: "Verdana", fontSize: 24.0)
    private let physicsWorld = CCPhysicsNode()
    private var player:Player?
    private var canPlay = true
    private var gameOver = false
    private var score:Int = 0
    private var delayGeneratePirate:Double = 1.0
    private var podeGerar:Bool = true
	
	// MARK: - Life Cycle
	override init() {
		super.init()

        //Carrega plist
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("PirataPeixe-ipad.plist")
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("PirataPerneta-ipad.plist")   
        
        // Deixa o jogo clicável
        self.userInteractionEnabled = true
        
        
        // Ativa a fisica
        physicsWorld.collisionDelegate = self
        self.addChild(self.physicsWorld, z: 3)
        
        //
        // Background
        //
        background.anchorPoint = CGPointMake( 0.5, 0.5 )
        background.position = CGPointMake( screenSize.width / 2, screenSize.height / 2 )
        self.addChild(background, z: 0)
        
        
        //
        // Faixa
        //
        faixa.anchorPoint = CGPointMake( 0.0, 0.0 )
        faixa.position = CGPointMake( 0.0, 0.0 )
        self.addChild(faixa, z: 1)
        
        
        //
        // Player
        //
        player = Player(event: "permitePwrUp", targetID: self)
        player!.anchorPoint = CGPointMake( 0.0, 0.0 )
        player!.position = CGPointMake( 10.0, screenSize.height / 2 + 50 )
        self.addChild(player, z: 2)
        
        
        //
		// Label score
        //
		labelScore.color = CCColor.blackColor()
		labelScore.position = CGPointMake(self.screenSize.width/2, self.screenSize.height - 10)
		labelScore.anchorPoint = CGPointMake(0.5, 1.0)
		self.addChild(labelScore, z: 10)

        
        //
		// Back button
        //
		backButton.position = CGPointMake(self.screenSize.width - 10, self.screenSize.height - 10)
		backButton.anchorPoint = CGPointMake(1.0, 1.0)
		backButton.zoomWhenHighlighted = false
		backButton.block = { _ in
            if StateMachine.sharedInstance.isPaused() {
                StateMachine.sharedInstance.pause()
            }
           
            StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)
             OALSimpleAudio.sharedInstance().playEffect("SoundFXButtonTap.mp3")
        }
        backButton.color = CCColor.blackColor()
        self.addChild(backButton, z: 10)
        
        
        //
        // Pause button
        //
        pauseButton.position = CGPointMake(self.screenSize.width - 140, self.screenSize.height - 10)
        pauseButton.anchorPoint = CGPointMake(1.0, 1.0)
        pauseButton.zoomWhenHighlighted = false
        pauseButton.block = { _ in
             OALSimpleAudio.sharedInstance().playEffect("SoundFXButtonTap.mp3")
            if(self.canPlay){
                StateMachine.sharedInstance.pause()
                self.canPlay = !StateMachine.sharedInstance.isPaused()
                if !self.canPlay {
                    self.showResume()
                } else {
                    self.hideResume()
                }
            }
        }
        pauseButton.color = CCColor.blackColor()
        self.addChild(pauseButton, z: 10)
        
        
        //
        // Label Paused
        //
        labelPaused1.anchorPoint = CGPointMake( 0.5, 0.5 )
        labelPaused1.position = CGPointMake( screenSize.width / 2, screenSize.height / 2 )
        labelPaused1.color = CCColor.redColor()
        labelPaused1.opacity = 0.0
        self.addChild(labelPaused1, z: 10)
        
        labelPaused2.anchorPoint = CGPointMake( 0.5, 0.5 )
        labelPaused2.position = CGPointMake( screenSize.width / 2, screenSize.height / 2 - 40 )
        labelPaused2.color = CCColor.redColor()
        labelPaused2.opacity = 0.0
        self.addChild(labelPaused2, z: 10)
        
        
        //
        // Label GameOver
        //
        labelGameOver1.anchorPoint = CGPointMake( 0.5, 0.5 )
        labelGameOver1.position = CGPointMake( screenSize.width / 2, screenSize.height / 2 )
        labelGameOver1.color = CCColor.redColor()
        labelGameOver1.opacity = 0.0
        self.addChild(labelGameOver1, z: 10)
        
        labelGameOver2.anchorPoint = CGPointMake( 0.5, 0.5 )
        labelGameOver2.position = CGPointMake( screenSize.width / 2, screenSize.height / 2 - 40 )
        labelGameOver2.color = CCColor.redColor()
        labelGameOver2.opacity = 0.0
        self.addChild(labelGameOver2, z: 10)
        
	}

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
        
        DelayHelper.sharedInstance.callFunc("generatePirate", onTarget: self, withDelay: self.delayGeneratePirate)
	}

	// Tick baseado no FPS
	override func update(delta: CCTime) {
		//...
	}

	// MARK: - Private Methods

	// MARK: - Public Methods
	
	// MARK: - Delegates/Datasources
	
	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        
        // Se o cara não pode jogar, ou está pausado ou é game over
        if !self.canPlay {
            if !self.gameOver {
            if StateMachine.sharedInstance.isPaused(){
                StateMachine.sharedInstance.pause()
                hideResume()
            } else {
                hideGameOver()
            }
            }
            else{
                StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade: true)
            }
        }
        else{
            let touchLocation:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
            let tiro:Tiro = Tiro(
                //event: "",target: self,
                click: touchLocation,
                viking: player!.position)
            tiro.position = CGPointMake( 40, screenSize.height / 2 + 70 )
            tiro.anchorPoint = CGPointMake(0,0)
            tiro.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, tiro.getBoundingBox().width - 10, tiro.getBoundingBox().height - 10), cornerRadius: 0.0)
            tiro.physicsBody.type = CCPhysicsBodyType.Kinematic
            //        self.physicsBody.friction = 1.0
            //        self.physicsBody.elasticity = 0.1
            //        self.physicsBody.mass = 100.0
            //        self.physicsBody.density = 100.0
            tiro.physicsBody.collisionType = "tiro"
            tiro.physicsBody.collisionCategories = ["tiro"]
            tiro.physicsBody.collisionMask = ["pirata"]

            self.physicsWorld.addChild(tiro, z: 2)
            tiro.moveMe()
            
        }
    }
    
    
    func generatePirate() {
        if (self.canPlay) {
            
            let pirate:Pirata = Pirata(event: "levaDano", target: self, score: self.score)
            pirate.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, pirate.getBoundingBox().width - 10, pirate.getBoundingBox().height - 10), cornerRadius: 0.0)
            pirate.physicsBody.type = CCPhysicsBodyType.Kinematic
            pirate.physicsBody.collisionType = "pirata"
            pirate.physicsBody.collisionCategories = ["pirata"]
            pirate.physicsBody.collisionMask = ["tiro"]
            pirate.position = CGPointMake( 1030, CGFloat(arc4random_uniform(550)) + 100 )
            pirate.moveMe()
            self.physicsWorld.addChild(pirate, z: 3)
            
            // Apos geracao, registra nova geracao apos um tempo
            DelayHelper.sharedInstance.callFunc("generatePirate", onTarget: self, withDelay: self.delayGeneratePirate)
        }
    }
    
    func configFaixa(imageName:String) {
        self.faixa.spriteFrame = CCSprite(imageNamed: imageName).spriteFrame
    }
    
    func levaDano(){
        self.player!.levaDano()
        
        if self.player!.getVida() == 2 {
            configFaixa(GameSceneEnergiaImages.EnergiaAmarela.rawValue)
        } else if self.player!.getVida() == 1 {
            configFaixa(GameSceneEnergiaImages.EnergiaVermelha.rawValue)
        } else {
            showGameOver()
        }
    }
    
    func showGameOver() {
        self.canPlay = false
        self.gameOver = true
        self.labelGameOver1.opacity = 1.0
        self.labelGameOver2.opacity = 1.0
        
        // Salva a maior pontuação
        let highScore:Int = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
        if(score > highScore){
            NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "highScore")
        }
    }
    
    func hideGameOver() {
        self.labelGameOver1.opacity = 0.0
        self.labelGameOver2.opacity = 0.0
    }
    
    func showResume() {
            self.canPlay = false
            self.labelPaused1.opacity = 1.0
            self.labelPaused2.opacity = 1.0
    }
    
    func hideResume() {
        self.canPlay = true
        self.labelPaused1.opacity = 0.0
        self.labelPaused2.opacity = 0.0
    }
    func gerarPwrUp(ponto:CGPoint){
        if(podeGerar){
            let porc:CGFloat = CGFloat(arc4random_uniform(100)+1)
            if(porc <= 10){
                podeGerar = false
                let pwr:PowerUp = PowerUp(eventStart: "pwrUpForca", eventEnd: "pwrUpForcaAcaba", targetID: player!)
                pwr.anchorPoint = CGPointMake( 0.5, 0.5 )
                pwr.position = ponto
                self.addChild(pwr, z:3)
           }
        }
    }
    func permitePwrUp(){
        podeGerar = true
    }
    func somarPontos(ponto:Int){
        score += ponto
        labelScore.string = "Score: \(score)"
    }
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, tiro tir: Tiro!, pirata pir: Pirata!) -> Bool {
        
        let pontos:Int = pir.tomaDano(self.player!.getForca())
        if( pontos != 0 ){
            somarPontos(pontos)
            
            self.gerarPwrUp(CGPoint(x: pir.position.x, y: pir.position.y))
        }
        
        tir.stopAllSpriteActions()
        tir.removeFromParentAndCleanup(true)
        return true
    }
}
