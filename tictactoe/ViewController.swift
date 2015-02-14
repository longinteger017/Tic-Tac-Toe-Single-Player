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
    
    @IBAction func newGameButton(sender: AnyObject) {
        newGame()
    }
    var winningComboniations = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    var playerOneMoves:Array<Int> = []
    var playerTwoMoves:Array<Int> = []
    var playerTurn = 1
    
    func newGame() {
        playerOneMoves.removeAll(keepCapacity: false)
        playerTwoMoves.removeAll(keepCapacity: false)
        for index in 1...9 {
            var tile = self.view.viewWithTag(index) as UIButton
            tile.setTitle("",forState: UIControlState.Normal)
        }
        statusLabel.text = "Player 1's turn!"
        playerTurn = 1
    }
    
    func isWinner(player: Int) -> Int {
        var winner = 0
        var moveList = [Int]()
        playerOneMoves.sort { $0 < $1 }
        playerTwoMoves.sort { $0 < $1 }
        if player == 1 {
            moveList = playerOneMoves
        }
        else {
            moveList = playerTwoMoves
           }
        
        for combo in winningComboniations  {
            if contains(moveList, combo[0]) && contains(moveList, combo[1]) && contains(moveList, combo[2]) && moveList.count > 2 {
                
                winner = player
                statusLabel.text = "Player \(player)'s' has won the game!"
                
                
            }
        }
        println(winner)
        return winner
    }
    @IBAction func buttonPress(sender: AnyObject) {
        if contains(playerTwoMoves, sender.tag) || contains(playerOneMoves, sender.tag) {
            statusLabel.text = "Square already used!"
        } else {
        
        if playerTurn % 2 == 0 {
            playerTwoMoves.append(sender.tag)
            
            sender.setTitle("X", forState: UIControlState.Normal)
            statusLabel.text = "Player 1's turn!"
            isWinner(2)
        }
        else {
            playerOneMoves.append(sender.tag)
            
            sender.setTitle("O", forState: UIControlState.Normal)
            statusLabel.text = "Player 2's turn!"
            isWinner(1)
        }
        
        playerTurn++
            if playerTurn > 9 && isWinner(1) < 1 {
                statusLabel.text = "Cat Game"
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

