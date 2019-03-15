//
//  GameInfo.swift
//  PallanKuzhi
//
//  Created by Neenu Babu on 3/14/19.
//  Copyright © 2019 Games. All rights reserved.
//

import SpriteKit
class GameInfo: SKScene {
    private var gameInfoLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        gameInfoLabel = self.childNode(withName: "//GameInfo") as? SKLabelNode
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNodes = self.nodes(at: pos)
        
        let touchedStartGame = touchedNodes.filter({ (touchedNode) -> Bool in
            if let name = touchedNode.name {
                return name == "StartGame"
            }
            return false
        })
        
        if(!touchedStartGame.isEmpty) {
            startGame()
        }
    }
    
    func startGame() {
        self.run(SKAction.wait(forDuration: 0.5))
        let reveal = SKTransition.doorway(withDuration: 1.0)
        if let gameInfo = GameScene(fileNamed: "GameScene") {
            self.view?.presentScene(gameInfo, transition: reveal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchDown(atPoint: t.location(in: self))}
    }
}
