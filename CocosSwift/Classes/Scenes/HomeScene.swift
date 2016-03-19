//
//  HomeScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class HomeScene : CCScene {
	// MARK: - Public Objects

	// MARK: - Private Objects
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()

	// MARK: - Life Cycle
	override init() {
		super.init()

        //
        // Background
        //
		let background:CCSprite = CCSprite(imageNamed: "background.png")
        background.anchorPoint = CGPointMake( 0.5, 0.5 )
        background.position = CGPointMake( screenSize.width / 2, screenSize.height / 2 )
        self.addChild(background, z: 0)

        
        //
		// High Score
        //
        let pontuacao:Int = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
		let labelHighScore:CCLabelTTF = CCLabelTTF(string: "High Score: \(pontuacao)", fontName: "Chalkduster", fontSize: 32.0)
		labelHighScore.color = CCColor.blackColor()
		labelHighScore.position = CGPointMake(self.screenSize.width/2, 20)
		labelHighScore.anchorPoint = CGPointMake(0.5, 0.0)
        self.addChild(labelHighScore, z: 1)
        

        //
		// ToGame Button
        //
		let toGameButton:CCButton = CCButton(title: "[ Start ]", fontName: "Verdana-Bold", fontSize: 38.0)
        toGameButton.color = CCColor.blackColor()
		toGameButton.position = CGPointMake(self.screenSize.width/2.0, self.screenSize.height/2.0)
		toGameButton.anchorPoint = CGPointMake(0.5, 0.5)
		toGameButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade:true)
         OALSimpleAudio.sharedInstance().playEffect("SoundFXButtonTap.mp3")}
        toGameButton.zoomWhenHighlighted = false
       
        self.addChild(toGameButton, z: 1)
	}

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
	}

	// MARK: - Private Methods
//	func startTap(sender:AnyObject) {
//		StateMachine.sharedInstance.changeScene(StateMachine.StateMachineScenes.GameScene, isFade:true)
//	}

	// MARK: - Public Methods

	// MARK: - Delegates/Datasources

	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
}
