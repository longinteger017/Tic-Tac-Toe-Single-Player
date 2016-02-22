 //
//  ViewController.swift
//  tictactoe
//
//  Created by Marcus on 2/10/15.
//  Copyright (c) 2015 Marcus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
   
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    
    var winningComboniations = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    var playerOneMoves = Set<Int>()
    var playerTwoMoves = Set<Int>()
    var possibleMove = Array<Int>()
    var playerTurn = 1
    var nextMove:Int?  = nil
    var spacesLeft = Set<Int>()
    let allSpaces: Set<Int> = [1,2,3,4,5,6,7,8,9]


    
    
    @IBAction func newGameButton(sender: AnyObject) {
        // start new game
        newGame()
        
    }
    
    

    
    func playDefense() -> Int{
        
        let playList = playerOneMoves
        let playList2 = playerTwoMoves
        var possibleLoses = Array<Array<Int>>()
        var possibleWins = Array<Array<Int>>()
        
        
        // determine what spaces are open
        spacesLeft = allSpaces.subtract(playerOneMoves.union(playerTwoMoves))

        // check for any possible winning/losing plays for human player
        // checks each possible winning combo and sees if human player is holding 2 spaces with computer holding none or vis a versa
        for combo in winningComboniations {
            var count = 0
            for play in combo {
                
                if playList.contains(play) {
                    
                    count++
                    
                }
                
                if playList2.contains(play) {
                    
                    count--
                    
                }
                
                if count == 2 {
                    
                    possibleLoses.append(combo)
                    count = 0
                    
                }
                
                if count == -2 {
                    
                    possibleWins.append(combo)
                    count = 0
                    
                }
                
            }
            
            
        }
        
        // if finds any possible winning moves add them to possible moves set
        if possibleWins.count > 0 {
            for combo in possibleWins {
                for spot in combo {
                    if playList2.contains(spot) || playList.contains(spot) {
                        
                    } else {
                        possibleMove.append(spot)
                    }
                }
            }
        }
        
        // if finds any possible losing moves add them to possible moves set
        if possibleLoses.count > 0 {
            for combo in possibleLoses {
                for spot in combo {
                    if playList.contains(spot) || playList2.contains(spot) {
                        
                    } else {
                        possibleMove.append(spot)
                    }
                }
            }
        }
        
        // if no possible wins or loses pick an empty spot
        if possibleMove.count > 0 {
            
            nextMove = possibleMove[Int(arc4random_uniform(UInt32(possibleMove.count)))]
            
        } else {
            
            if spacesLeft.count > 0 {
                
                nextMove = spacesLeft[spacesLeft.startIndex.advancedBy(Int(arc4random_uniform(UInt32(possibleMove.count))))]
                
            }
        }
        
        
        
        print("possible wins \(possibleWins)")
        print("possible loses \(possibleLoses)")
        print("used spaces \(playList) \(playList2)")
        print("possible moves \(possibleMove)")
        print("next move \(nextMove!)")
        
        possibleMove.removeAll(keepCapacity: false)
        possibleLoses.removeAll(keepCapacity: false)
        possibleWins.removeAll(keepCapacity: false)
        
        playerTurn++
        spacesLeft.insert(nextMove!)
        
        return nextMove!
    }
    
    func newGame() {
        // clear move list
        playerOneMoves.removeAll(keepCapacity: false)
        playerTwoMoves.removeAll(keepCapacity: false)
        
        
        // clear and setup buttons
        for index in 1...9 {
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.enabled = true
            tile.setTitle("",forState: UIControlState.Normal)
        }
        statusLabel.text = "Player 1's turn!"
        playerTurn = 1
        
    }
    
    func isWinner(player: Int) -> Int {
        var winner = 0
        var moveList = Set<Int>()

        //make sure we are looking at right player moves
        if player == 1 {
            
            moveList = playerOneMoves
        
        } else {
            
            moveList = playerTwoMoves
            
        }
        
        // check and see if there are any winning combonations
        for combo in winningComboniations  {
            if moveList.contains(combo[0]) && moveList.contains(combo[1]) && moveList.contains(combo[2]) && moveList.count > 2 {
                
                winner = player
                statusLabel.text = "Player \(player) has won the game!"
                for index in 1...9 {
                    let tile = self.view.viewWithTag(index) as! UIButton
                    tile.enabled = false
                    }
                
                
            }
        }
        
        
        return winner
    }
    
    
    @IBAction func buttonPress(sender: AnyObject) {
        
        // if button already selected infom the user
        if playerTwoMoves.contains(sender.tag) || playerOneMoves.contains(sender.tag) {
            
            statusLabel.text = "Square already used!"
            
        } else {
        
            if playerTurn % 2 == 0 {
                
            } else {
                
                //add button to player move list
                playerOneMoves.insert(sender.tag)
                sender.setTitle("O", forState: UIControlState.Normal)
                statusLabel.text = "Player 2's turn!"
                if isWinner(1) == 0 {
                    
                    // if no winner play defense
                    let nextMove = playDefense()
                    playerTwoMoves.insert(nextMove)
                    let tmpButton = self.view.viewWithTag(nextMove) as! UIButton
                    tmpButton.setTitle("X", forState: UIControlState.Normal)
                    statusLabel.text = "Player 1's turn!"
                    
                    //check and see if computer won
                    isWinner(2)
                    
                }
            }
            
            // if all 9 turns used up and no winner call draw
            playerTurn++
            if playerTurn > 9 && isWinner(1) < 1 {
                statusLabel.text = "Cat Game"
                for index in 1...9 {
                    let tile = self.view.viewWithTag(index) as! UIButton
                    tile.enabled = false
                }

            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        newGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

