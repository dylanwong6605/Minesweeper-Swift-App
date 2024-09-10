/*:
 Final Project
 CIS 137 Summer 2024
 Dylan Wong
 */
import SwiftUI

class MinesweeperGame : ObservableObject {
    @Published var model : Board = createMinesweeperGame()
    
    static func createMinesweeperGame () -> Board {
        return Board(9, 11)
    }
    
    var numOfMines : Int {
        return model.numOfMines
    }
    
    var board : Array <Board.Space> {
        return model.displayBoard
    }
    
    var bombRevealed: Bool {
        return model.bombRevealed
    }
    
    var won: Bool {
        return model.won
    }
    
    func reset () {
        model.reset()
    }
    
    func revealSpace(_ row: Int, _ col: Int) {
        model.revealSpace(row, col)
    }
    
    func placeFlag(_ index: Int) {
        model.placeFlag(index)
    }
}
