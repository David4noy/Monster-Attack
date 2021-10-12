//
//  GameOverScene.swift
//  ShootingGame
//
//  Created by דוד נוי on 11/10/2021.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let startPauseButton = SKLabelNode(fontNamed: "Charter")
    var start = SKAction()
    let background = SKSpriteNode(imageNamed: "background")
    let backgroundIpad = SKSpriteNode(imageNamed: "backgroundipad")
    
  init(size: CGSize, won:Bool) {
    super.init(size: size)
    
    // 1
 //   backgroundColor = SKColor.white
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        
        background.zPosition = 0
        background.position = CGPoint(x: frame.size.width / 2 , y: frame.size.height / 2)
        addChild(background)
        
    } else {
        
        backgroundIpad.zPosition = 0
        backgroundIpad.position = CGPoint(x: frame.size.width / 2 , y: frame.size.height / 2)
        addChild(backgroundIpad)

    }
    
    // 2
    let message: String
    
    if won {
        message = "You Won! 😃"
        Levels.level += 1
        run(SKAction.playSoundFileNamed("victory.mp3", waitForCompletion: false))
    } else {
        message = "You Lose 😢"
        run(SKAction.playSoundFileNamed("lost.mp3", waitForCompletion: false))
    }
        
    // 3
    let label = SKLabelNode(fontNamed: "Chalkduster")
    label.text = message
    label.fontSize = 70
    label.fontColor = SKColor.black
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    label.zPosition = 1
    addChild(label)
    
    addStartPauseButton()
    
    start = SKAction.run() { [weak self] in
        // 5
        guard let `self` = self else { return }
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:reveal)
      }
    
    // 4
    run(SKAction.sequence([
      SKAction.wait(forDuration: 3.0),
        start
      ]))
   }
  
  // 6
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    func addStartPauseButton(){

        startPauseButton.text =  "Start"
        startPauseButton.fontSize = 30
        startPauseButton.fontColor = SKColor.green
        startPauseButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.85)
        startPauseButton.zPosition = 1
        addChild(startPauseButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        
        if startPauseButton.contains(location) {
            run(start)
        }
        
    }
    
}
