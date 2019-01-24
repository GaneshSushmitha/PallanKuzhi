//
//  GameScene.swift
//  PallanKuzhi
//
//  Created by Sushmitha on 1/22/19.
//  Copyright © 2019 Games. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var title : SKLabelNode?
    private var spinnyNode : SKShapeNode?

    private var board: SKSpriteNode?
    
    private var pitSquare00: SKSpriteNode?
    private var pitShape00: SKShapeNode?
    private var pitSquare01: SKSpriteNode?
    private var pitShape01: SKShapeNode?
    private var pitSquare02: SKSpriteNode?
    private var pitShape02: SKShapeNode?
    private var pitSquare03: SKSpriteNode?
    private var pitShape03: SKShapeNode?
    private var pitSquare04: SKSpriteNode?
    private var pitShape04: SKShapeNode?
    private var pitSquare05: SKSpriteNode?
    private var pitShape05: SKShapeNode?
    private var pitSquare06: SKSpriteNode?
    private var pitShape06: SKShapeNode?
    
    private var pitSquare10: SKSpriteNode?
    private var pitShape10: SKShapeNode?
    private var pitSquare11: SKSpriteNode?
    private var pitShape11: SKShapeNode?
    private var pitSquare12: SKSpriteNode?
    private var pitShape12: SKShapeNode?
    private var pitSquare13: SKSpriteNode?
    private var pitShape13: SKShapeNode?
    private var pitSquare14: SKSpriteNode?
    private var pitShape14: SKShapeNode?
    private var pitSquare15: SKSpriteNode?
    private var pitShape15: SKShapeNode?
    private var pitSquare16: SKSpriteNode?
    private var pitShape16: SKShapeNode?


    override func didMove(to view: SKView) {
        
        // Get title node from scene
        self.title = self.childNode(withName: "//PallanKuzhi") as? SKLabelNode
        
        self.board = self.childNode(withName: "//Board") as? SKSpriteNode
        
        if let board = self.board {
            self.pitSquare00 = board.childNode(withName: "//PitSquare00") as? SKSpriteNode
            self.pitSquare01 = board.childNode(withName: "//PitSquare01") as? SKSpriteNode
            self.pitSquare02 = board.childNode(withName: "//PitSquare02") as? SKSpriteNode
            self.pitSquare03 = board.childNode(withName: "//PitSquare03") as? SKSpriteNode
            self.pitSquare04 = board.childNode(withName: "//PitSquare04") as? SKSpriteNode
            self.pitSquare05 = board.childNode(withName: "//PitSquare05") as? SKSpriteNode
            self.pitSquare06 = board.childNode(withName: "//PitSquare06") as? SKSpriteNode
            self.pitSquare10 = board.childNode(withName: "//PitSquare10") as? SKSpriteNode
            self.pitSquare11 = board.childNode(withName: "//PitSquare11") as? SKSpriteNode
            self.pitSquare12 = board.childNode(withName: "//PitSquare12") as? SKSpriteNode
            self.pitSquare13 = board.childNode(withName: "//PitSquare13") as? SKSpriteNode
            self.pitSquare14 = board.childNode(withName: "//PitSquare14") as? SKSpriteNode
            self.pitSquare15 = board.childNode(withName: "//PitSquare15") as? SKSpriteNode
            self.pitSquare16 = board.childNode(withName: "//PitSquare16") as? SKSpriteNode
        }

        
        if let title = self.title {
            title.alpha = 0.0
            title.run(SKAction.fadeIn(withDuration: 0.5))
        }
        
        // Create shape node to use during touch interaction
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: 20.0, height: 20.0), cornerRadius: 8.0)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 0.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
