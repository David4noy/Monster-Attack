//
//  GameScene.swift
//  ShootingGame
//
//  Created by דוד נוי on 11/10/2021.
//
// Used image from J. W. Bjerk (eleazzaar) -- www.jwbjerk.com/art -- find this and other open art at: http://opengameart.org
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    let worldNode = SKNode()
    let player = SKSpriteNode(imageNamed: "wizard")
    let background = SKSpriteNode(imageNamed: "background")
    let backgroundIpad = SKSpriteNode(imageNamed: "backgroundipad")
    var monstersDestroyed = 0
    var monstersPassed = 0
    let resultLabel = SKLabelNode(fontNamed: "Charter")
    let startPauseButton = SKLabelNode(fontNamed: "Charter")
    let levelLabel = SKLabelNode(fontNamed: "Charter")
    var levelNum = 1
    var deads = 100
    var hearts = 3
    var monstersEnterTime = 0.1
    var minMonsterSpeed = 1.0
    var maxMonsterSpeed = 4.5
    
    var started = false
    
    let backgrounZ: CGFloat = 0
    let aboveBackgrounZ: CGFloat = 1
    let aboveBackgrounZ2: CGFloat = 2
    let spriteZ: CGFloat = 3
    
    
    override func sceneDidLoad() {
        
        setLevel()
        
        addChild(worldNode)
        worldNode.isPaused = true
        started = false
        addResultesLabel()
        addStartPauseButton()
        deviceCheck()
    }
    
    func addStartPauseButton(){
        
        startPauseButton.text = worldNode.isPaused ? "Start" : "Pause"
        startPauseButton.numberOfLines = 0
        startPauseButton.fontSize = 35
        startPauseButton.fontColor = SKColor.red
        startPauseButton.zPosition = aboveBackgrounZ
        addChild(startPauseButton)
    }
    
    func setLevel(){
        
        let defaults = UserDefaults.standard
        Levels.level = defaults.integer(forKey: "level")
        
        if Levels.level > 5 || Levels.level < 1 {
            Levels.level = 1
        }
                
        let level = Levels.getLevel()
        
        levelNum = level.level
        deads = level.deads
        hearts = level.hearts
        monstersEnterTime = level.monstersEnterTime
        minMonsterSpeed = level.minMonsterSpeed
        maxMonsterSpeed = level.maxMonsterSpeed
        
        levelLabel.text = "Level: \(levelNum)"
        levelLabel.numberOfLines = 0
        levelLabel.fontSize = 25
        levelLabel.fontColor = SKColor.blue
        levelLabel.zPosition = aboveBackgrounZ2
        addChild(levelLabel)
        
    }
    
    func addResultesLabel(){
        resultLabel.text = "❤️ \(hearts - monstersPassed)\n🔥 \(monstersDestroyed)/\(deads)"
        resultLabel.numberOfLines = 0
        resultLabel.fontSize = 25
        resultLabel.fontColor = SKColor.white
        resultLabel.zPosition = aboveBackgrounZ2
        addChild(resultLabel)
        
    }
    
    func deviceCheck(){
        
        if UIDevice.current.userInterfaceIdiom == .phone {

            levelLabel.position = CGPoint(x: size.width * 0.85, y: size.height * 0.85)
            resultLabel.position = CGPoint(x: size.width * 0.85, y: size.height * 0.65)
            startPauseButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.85)

            background.zPosition = backgrounZ
            background.position = CGPoint(x: frame.size.width / 2 , y: frame.size.height / 2)
            addChild(background)
            
        } else {
            
            levelLabel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
            resultLabel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.8)
            startPauseButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
            
            backgroundIpad.zPosition = backgrounZ
            backgroundIpad.position = CGPoint(x: frame.size.width / 2 , y: frame.size.height / 2)
            addChild(backgroundIpad)
 
        }
        
    }
    

    
    override func didMove(to view: SKView) {
        
        //  backgroundColor = SKColor.white
        

        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        worldNode.addChild(player)
        player.zPosition = spriteZ
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        
        
    }
    
    func runGame(){
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: monstersEnterTime)
            ])
        ))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
                
        if !worldNode.isPaused{

            // Create sprite
            let monsterType = Int(random(min: 1, max: 6))
            var monster = SKSpriteNode()
            
            switch monsterType {
            case 1:
                monster = SKSpriteNode(imageNamed: "dragon")
            case 2:
                monster = SKSpriteNode(imageNamed: "doom_gameart")
            case 3:
                monster = SKSpriteNode(imageNamed: "creature1")
            case 4:
                monster = SKSpriteNode(imageNamed: "skeleton")
            case 5:
                monster = SKSpriteNode(imageNamed: "chicken")
            default:
                monster = SKSpriteNode(imageNamed: "dragon")
            }
            
            // Determine where to spawn the monster along the Y axis
            let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
            
            // Position the monster slightly off-screen along the right edge,
            // and along a random position along the Y axis as calculated above
            monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
            monster.zPosition = spriteZ
            // Add the monster to the scene
            worldNode.addChild(monster)
            
            monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
            monster.physicsBody?.isDynamic = true // 2
            monster.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
            monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
            monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
            
            
            // Determine speed of the monster
            let actualDuration = random(min: CGFloat(minMonsterSpeed), max: CGFloat(maxMonsterSpeed))
            
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY),
                                           duration: TimeInterval(actualDuration))
            let actionMoveDone = SKAction.removeFromParent()
            
            let loseAction = SKAction.run() { [weak self] in
                guard let `self` = self else { return }
                
                self.monstersPassed += 1
                self.resultLabel.text = "❤️ \(self.hearts - self.monstersPassed)\n🔥 \(self.monstersDestroyed)/\(self.deads)"
                if self.monstersPassed > 2 {
                    let reveal = SKTransition.flipVertical(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: false)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
            }
            monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        if startPauseButton.contains(touchLocation) {
            worldNode.isPaused = !worldNode.isPaused
            startPauseButton.text = worldNode.isPaused ? "Start" : "Pause"
            
            if !started {
                runGame()
                worldNode.isPaused = false
                startPauseButton.text =  "Pause"
                
                worldNode.removeAllChildren()
                worldNode.addChild(player)
                
            let backgroundMusic = SKAudioNode(fileNamed: "background-music.mp3")
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
                started = true
            }
            
        } else {
            
            run(SKAction.playSoundFileNamed("shoot.wav", waitForCompletion: false))
            
            // 2 - Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "fireball")
            projectile.position = CGPoint(x: size.width * 0.14, y: size.height * 0.55)                  //player.position
            projectile.zPosition = spriteZ
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            
            // 3 - Determine offset of location to projectile
            let offset = touchLocation - projectile.position
            
            // 4 - Bail out if you are shooting down or backwards
            if offset.x < 0 { return }
            
            // 5 - OK to add now - you've double checked position
            worldNode.addChild(projectile)
            
            // 6 - Get the direction of where to shoot
            let direction = offset.normalized()
            
            // 7 - Make it shoot far enough to be guaranteed off screen
            let shootAmount = direction * 1000
            
            // 8 - Add the shoot amount to the current position
            let realDest = shootAmount + projectile.position
            
            // 9 - Create the actions
            let actionMove = SKAction.move(to: realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        }
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        
        // run(SKAction.playSoundFileNamed("boom.wav", waitForCompletion: false))
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed += 1
        resultLabel.text = "❤️ \(hearts - monstersPassed)\n🔥 \(monstersDestroyed)/\(deads)"
        if monstersDestroyed > deads {
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode,
               let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
    }
    
}
