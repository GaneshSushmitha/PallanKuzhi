//
//  GameScene.swift
//  PallanKuzhi
//
//  Created by Sushmitha on 1/22/19.
//  Copyright © 2019 Games. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Player : String {
    case player1
    case player2
}

class GameScene: SKScene {
    
    private var title : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var board: SKSpriteNode?
    
    private var touchedPitNode : SKShapeNode?
    
    private var pits = [SKShapeNode](repeating: SKShapeNode(), count: 14) //initializing array of shapenode ()-> constructor call
    
    private var pitNeighbours = [(from: SKShapeNode, to: SKShapeNode)]()
    
    private var currentPlayer = Player.player1
    
    private var player1Pits = [SKShapeNode](repeating: SKShapeNode(), count: 7)
    
    private var player2Pits = [SKShapeNode](repeating: SKShapeNode(), count: 7)
    
    private var playerSprite1 : SKSpriteNode?
    
    private var playerSprite2 : SKSpriteNode?
    
    private var gameInfo : SKSpriteNode?
    
    private var playerScoreValue1 : SKLabelNode?
    
    private var playerScoreValue2 : SKLabelNode?
    
    private var player1Score : Int = 0
    
    private var player2Score : Int = 0
    
    private var validPitTouched = true
    
    let pitColor = UIColor(red: CGFloat(215.0 / 255.0), green: CGFloat(240.0 / 255.0), blue: CGFloat(30.0 / 255.0), alpha: CGFloat(1.0))
    
    let playerSpriteScaleUp = SKAction.scale(to: 1.2, duration: 0.8)
    
    let playerSpriteScaleDown = SKAction.scale(to: 1.0, duration: 0.8)
    
    let playerSpriteMoveUp = SKAction.moveBy(x: 0.0, y: 50.0, duration: 0.5)
    
    let playerSpriteMoveDown = SKAction.moveBy(x: 0.0, y: -50.0, duration: 0.5)
    
    override func didMove(to view: SKView) {
        
        // Get title node from scene
        self.title = self.childNode(withName: "//PallanKuzhi") as? SKLabelNode
        
        self.board = self.childNode(withName: "//Board") as? SKSpriteNode
        
        self.playerSprite1 = board?.childNode(withName: "//PlayerSprite1") as? SKSpriteNode
        
        self.playerSprite2 = board?.childNode(withName: "//PlayerSprite2") as? SKSpriteNode
        
        self.gameInfo = board?.childNode(withName: "//GameInfo") as? SKSpriteNode
        
        self.playerScoreValue1 = self.childNode(withName: "//PlayerScoreValue1") as? SKLabelNode
        
        self.playerScoreValue2 = self.childNode(withName: "//PlayerScoreValue2") as? SKLabelNode
        
        self.name = "GameScene"
        
        populatePits()
        
        // Create neighbour relationships
        initialiseNeighbours()
        
        // Create seeds
        initialiseSeeds()
        
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
    
    func populatePits() {
        
        if let board = self.board {
            let pitSquare00 = board.childNode(withName: "//PitSquare00") as! SKSpriteNode // force casting SKNode to SKSpriteNode !
            let pitSquare01 = board.childNode(withName: "//PitSquare01") as! SKSpriteNode
            let pitSquare02 = board.childNode(withName: "//PitSquare02") as! SKSpriteNode
            let pitSquare03 = board.childNode(withName: "//PitSquare03") as! SKSpriteNode
            let pitSquare04 = board.childNode(withName: "//PitSquare04") as! SKSpriteNode
            let pitSquare05 = board.childNode(withName: "//PitSquare05") as! SKSpriteNode
            let pitSquare06 = board.childNode(withName: "//PitSquare06") as! SKSpriteNode
            let pitSquare10 = board.childNode(withName: "//PitSquare10") as! SKSpriteNode
            let pitSquare11 = board.childNode(withName: "//PitSquare11") as! SKSpriteNode
            let pitSquare12 = board.childNode(withName: "//PitSquare12") as! SKSpriteNode
            let pitSquare13 = board.childNode(withName: "//PitSquare13") as! SKSpriteNode
            let pitSquare14 = board.childNode(withName: "//PitSquare14") as! SKSpriteNode
            let pitSquare15 = board.childNode(withName: "//PitSquare15") as! SKSpriteNode
            let pitSquare16 = board.childNode(withName: "//PitSquare16") as! SKSpriteNode
            
            // Array of pit squares in anticlockwise order from pit square 10.
            let pitSquares = [pitSquare10,pitSquare11,pitSquare12,pitSquare13,pitSquare14,pitSquare15,pitSquare16,
                              pitSquare06,pitSquare05,pitSquare04,pitSquare03,pitSquare02,pitSquare01,pitSquare00]
            
            for (index, pitSquare) in pitSquares.enumerated() {
                let pit = SKShapeNode(circleOfRadius: 40.0)
                pit.fillColor = pitColor
                pit.name = "Pit\(pitSquare.name?.suffix(2) ?? "")"
                pitSquare.addChild(pit)
                pits[index] = pit
            }
            assignPlayerPits()
        }
    }
    
    func assignPlayerPits() {
        player1Pits = Array(pits[0...6])
        player2Pits = Array(pits[7...13])
    }
    
    func initialiseNeighbours() {
        let r1 = (pits[0],pits[1])
        let r2 = (pits[1],pits[2])
        let r3 = (pits[2],pits[3])
        let r4 = (pits[3],pits[4])
        let r5 = (pits[4],pits[5])
        let r6 = (pits[5],pits[6])
        let r7 = (pits[6],pits[7])
        let r8 = (pits[7],pits[8])
        let r9 = (pits[8],pits[9])
        let r10 = (pits[9],pits[10])
        let r11 = (pits[10],pits[11])
        let r12 = (pits[11],pits[12])
        let r13 = (pits[12],pits[13])
        let r14 = (pits[13],pits[0])
        
        pitNeighbours = [r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14]
    }
    
    func getNeighbour(pit : SKShapeNode) -> SKShapeNode {
        let r = pitNeighbours.first { (from: SKShapeNode, to: SKShapeNode) -> Bool in
            return from == pit
        }
        if let r = r {
            return r.to
        }
        return SKShapeNode()
    }
    
    func rearrangeSeeds(){
        
    }
    
    func initialiseSeeds(){
        for (pitNo, pit) in pits.enumerated() { //pit object + array index => enumerated
            
            //debug seeds
            //if pitNo > 0 {
            //  break
            //}
            
            for seedNo in 1...6 {
                
                let pitSeed = SKShapeNode(circleOfRadius: 8.0)
                pitSeed.fillColor = UIColor.init(red: (CGFloat(20.0) * CGFloat(seedNo) / 255.0), green: (CGFloat(30.0) * CGFloat(seedNo) / 255.0), blue: (CGFloat(40.0) * CGFloat(seedNo) / 255.0), alpha: 1.0)
                pitSeed.name = "PitSeed\(pitNo * 6 + seedNo)"
                
                
                pitSeed.position = originalSeedPos(seedNo, pitSeed)
                pit.addChild(pitSeed)
            }
        }
    }
    
    func displayNextPlayerTurn() {
        if currentPlayer == Player.player1 {
            playerSprite1?.run(playerSpriteScaleUp)
            playerSprite1?.run(playerSpriteMoveUp)
            playerSprite2?.run(playerSpriteScaleDown)
            playerSprite2?.run(playerSpriteMoveUp)
        } else {
            playerSprite2?.run(playerSpriteScaleUp)
            playerSprite2?.run(playerSpriteMoveDown)
            playerSprite1?.run(playerSpriteScaleDown)
            playerSprite1?.run(playerSpriteMoveDown)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
        
        //Track touch down of pits
        let touchedNodes = self.nodes(at: pos)
        let touchedPitNodes = touchedNodes.filter({ (touchedNode) -> Bool in
            if let name = touchedNode.name {
                return name.count == "PitXX".count && name.prefix(3) == "Pit"
            }
            return false
        })
        
        let touchedGameInfo = touchedNodes.filter({ (touchedNode) -> Bool in
            if let name = touchedNode.name {
                return name == "GameInfo"
            }
            return false
        })
        
        if(!touchedGameInfo.isEmpty) {
            displayGameInfo()
        }
        
        
        if let touchedPitNode = touchedPitNodes.first  as? SKShapeNode {
            self.touchedPitNode = touchedPitNode
            if validateTouchedPit() {
                highlightPit(color: UIColor.blue.withAlphaComponent(0.7))
                distributeSeeds()
            } else {
                highlightPit(color: UIColor.brown.withAlphaComponent(0.7))
            }
            print("Touched Down \(String(describing: self.touchedPitNode?.name)), Position: \(pos)")
        }
    }
    
    func  validateTouchedPit() -> Bool {
        
        // Check if valid turn of player
        if validateCurrentPlayerMove() {
            // Check if the pit has seeds
            if let touchedPitNode = self.touchedPitNode {
                let  childSeeds = touchedPitNode.children
                self.validPitTouched = !childSeeds.isEmpty
            }
        }
        else {
            self.validPitTouched = false
        }
        return self.validPitTouched
    }
    
    func validateCurrentPlayerMove() -> Bool {
        if let touchedPitNode = self.touchedPitNode {
            if currentPlayer == .player1 {
                return player1Pits.contains(touchedPitNode)
            } else {
                return player2Pits.contains(touchedPitNode)
            }
        }
        return false
    }
    
    func highlightPit(color : UIColor) {
        self.touchedPitNode?.fillColor = color
    }
    
    //Distribute seeds until an empty pit is encountered
    func distributeSeeds() {
        if let touchedPitNode = self.touchedPitNode {
            var currentPitNode = touchedPitNode
            while(!currentPitNode.children.isEmpty){
                let seeds = currentPitNode.children
                currentPitNode.removeAllChildren()
                setSeedCount(pit: currentPitNode)
                
                var neighborPit = getNeighbour(pit: currentPitNode)
                var neighborPitSeedCount = neighborPit.children.count
                for seed in seeds {
                    if(neighborPitSeedCount >= 6) {
                        let repositionFactor = neighborPitSeedCount - 6
                        seed.position = repositionSeeds(repositionFactor, seed)
                    } else {
                        seed.position = originalSeedPos(neighborPitSeedCount, seed)
                    }
                    neighborPit.addChild(seed)
                    //Set the seed count label
                    setSeedCount(pit: neighborPit)
                    neighborPit = getNeighbour(pit: neighborPit)
                    neighborPitSeedCount = neighborPit.children.count
                }
                currentPitNode = neighborPit
                //print((String(describing:currentPitNode.name)))
            }
            captureSeeds(pit: getNeighbour(pit: currentPitNode))
        }
    }
    
    func originalSeedPos(_ seedNo:Int, _ pitSeed:SKNode) -> CGPoint{
        switch seedNo {
        case 1:
            return CGPoint(x: 0.0, y: 32.0)
        case 2:
            return CGPoint(x: -24.0, y: 15.0)
        case 3:
            return CGPoint(x: -24.0, y: -15.0)
        case 4:
            return CGPoint(x: 0.0, y: -32.0)
        case 5:
            return CGPoint(x: 24.0, y: -15.0)
        case 6:
            return CGPoint(x: 24.0, y: 15.0)
        default:
            return CGPoint(x: 0.0, y: 0.0)
        }
    }
    
    func repositionSeeds(_ seedNo:Int, _ pitSeed:SKNode) -> CGPoint{
        switch seedNo {
        case 0:
            return CGPoint(x: 15.0, y: 22.0)
        case 1:
            return CGPoint(x: -14.0, y: 5.0)
        case 2:
            return CGPoint(x: -16.0, y: -5.0)
        case 3:
            return CGPoint(x: 15.0, y: -22.0)
        case 4:
            return CGPoint(x: 14.0, y: -5.0)
        case 5:
            return CGPoint(x: 17.0, y: 5.0)
        case 6:
            return CGPoint(x: 20.0, y: 5.0)
        case 7:
            return CGPoint(x: 19.0, y: 0.0)
        case 8:
            return CGPoint(x: 12.0, y: 2.0)
        case 9:
            return CGPoint(x: 10.0, y: -1.0)
        case 10:
            return CGPoint(x: 12.0, y: 4.0)
        case 11:
            return CGPoint(x: 21.0, y: -3.0)
        case 12:
            return CGPoint(x: 11.0, y: -1.0)
        case 13:
            return CGPoint(x: 14.0, y: 2.0)
        case 14:
            return CGPoint(x: 22.0, y: 5.0)
        case 15:
            return CGPoint(x: 18.0, y: 3.0)
        case 16:
            return CGPoint(x: 16.0, y: -8.0)
        default:
            return pitSeed.position
        }
    }
    
    func setSeedCount(pit: SKShapeNode)
    {
        if let pitName = pit.name {
            if let seedCount = self.childNode(withName: "//SeedCount" + pitName.suffix(2)) as? SKLabelNode {
                
                //Animate the changed seed count in neighbour pit
                seedCount.run(SKAction.sequence([SKAction.colorize(with: UIColor.blue, colorBlendFactor: 0.5, duration: 0.5),
                                                 SKAction.colorize(with: UIColor.yellow, colorBlendFactor: 0.5, duration: 0.5)]))
                //Set the new seed count
                seedCount.text = String(pit.children.count)
            }
        }
    }
    
    func captureSeeds(pit: SKShapeNode) {
        var capturedSeedCount : Int
        if let capturedPitName = pit.name {
            if !pit.children.isEmpty {
                capturedSeedCount = pit.children.count
                pit.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.wait(forDuration: 0.1), SKAction.fadeIn(withDuration: 0.3)]))
                pit.removeAllChildren()
                setSeedCount(pit: pit)
                updatePlayerScores(score: capturedSeedCount)
            }
        }
    }
    
    func updatePlayerScores(score: Int){
        if currentPlayer == .player1 {
            self.player1Score = player1Score + score
            playerScoreValue1?.text = String(player1Score)
            print("Player 1 Score \(String(player1Score))")
        } else {
            self.player2Score = player2Score + score
            playerScoreValue2?.text = String(player2Score)
            print("Player 2 Score \(String(player2Score))")
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
        if let touchedPitNode = self.touchedPitNode {
            touchedPitNode.fillColor = pitColor
            print("Touched Up \(String(describing: touchedPitNode.name)), Position: \(pos)")
            assignNextPlayer()
            self.touchedPitNode = nil
            self.validPitTouched = true
        }
    }
    
    func getSeedsAvailability(player: Player) -> Int {
        var availablePitsWithSeeds : Int = 0
        switch player {
        case .player1:
            for p in player2Pits { if !p.children.isEmpty {availablePitsWithSeeds += 1}}
            break
        case .player2:
            for p in player1Pits { if !p.children.isEmpty {availablePitsWithSeeds += 1}}
            break
        }
        return availablePitsWithSeeds
    }
    
    func assignNextPlayer() {
        if(getSeedsAvailability(player: currentPlayer)>0) {
            if(validPitTouched) {
                switch currentPlayer {
                case .player1:
                    currentPlayer = .player2
                case .player2:
                    currentPlayer = .player1
                }
                displayNextPlayerTurn()
            }
        } else {
            setWinner()
        }
    }
    
    func setWinner() {
        player1Score = player1Score + getSeedsAvailability(player: .player2)
        player2Score = player2Score + getSeedsAvailability(player: .player1)
        let winner : Player
        if(player1Score == player2Score) {
            winner = currentPlayer
        } else {
            winner = player1Score > player2Score ? .player1 : .player2
            print("Winner is: " + winner.rawValue)
        }
        
        //display winner and stop the game
        displayGameOverScene(winner: winner.rawValue, score: (winner == Player.player1) ? player1Score : player2Score )
    }

    func displayGameOverScene(winner: String, score: Int) {
        self.run(SKAction.wait(forDuration: 0.5))
        let reveal = SKTransition.doorway(withDuration: 1.0)
        if let gameOverScene = GameOverScene(fileNamed: "GameOverScene") {
            let userData = gameOverScene.userData ?? [:]
            userData["winner"] = winner
            userData["score"] = score
            gameOverScene.userData = userData
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func displayGameInfo() {
        self.run(SKAction.wait(forDuration: 0.5))
        let reveal = SKTransition.doorway(withDuration: 1.0)
        if let gameInfo = GameInfo(fileNamed: "GameInfo") {
            self.view?.presentScene(gameInfo, transition: reveal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchDown(atPoint: t.location(in: self))}
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

