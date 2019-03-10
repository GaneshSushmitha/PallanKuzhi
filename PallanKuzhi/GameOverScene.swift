//
//  GameOverScene.swift
//  PallanKuzhi
//
//  Created by Sushmitha on 3/9/19.
//  Copyright © 2019 Games. All rights reserved.
//

import SpriteKit
class GameOverScene: SKScene {
    private var winnerLabel: SKLabelNode?
    private var scoreLabel: SKLabelNode?

    override func didMove(to view: SKView) {
        winnerLabel = self.childNode(withName: "//Winner") as? SKLabelNode
        scoreLabel = self.childNode(withName: "//Score") as? SKLabelNode
        if let win = userData?["winner"] as? String {
            winnerLabel?.text = win
        }
        if let score = userData?["score"] as? Int {
            scoreLabel?.text = String(score)
        }
    }
}

