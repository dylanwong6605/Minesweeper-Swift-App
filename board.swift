import Foundation

struct Board {
    private(set) var gameBoard: [[Space]]
    private(set) var displayBoard: [Space]
    private(set) var numOfMines: Int
    private(set) var bombRevealed: Bool = false
    private(set) var won: Bool = false
    struct Space: Identifiable, Hashable {
        var content: String
        var isMine: Bool
        var revealed = false
        var flagPlaced = false
        var minesAdjacent = 0
        var id: Int
        var row: Int
        var col: Int
    }
    
    mutating func revealSpace(_ r: Int, _ c: Int) {
        if !displayBoard[gameBoard[r][c].id].revealed && !bombRevealed{
            if gameBoard[r][c].isMine {
                displayBoard[gameBoard[r][c].id].revealed = true
                bombRevealed = true
                revealBombs()
            }
            else if !gameBoard[r][c].isMine && gameBoard[r][c].minesAdjacent > 0 {
                displayBoard[gameBoard[r][c].id].revealed = true
            }
            else if !gameBoard[r][c].isMine && gameBoard[r][c].minesAdjacent == 0 {
                displayBoard[gameBoard[r][c].id].revealed = true
                if c < gameBoard[r].count-1{
                    revealSpace(r, c+1)
                }
                if c > 0{
                    revealSpace(r, c-1)
                }
                if r > 0 && c < gameBoard[r].count-1 {
                    revealSpace(r-1, c+1)
                }
                if r > 0 && c > 0 {
                    revealSpace(r-1, c-1)
                }
                if r < gameBoard.count-1 && c > 0 {
                    revealSpace(r+1, c-1)
                }
                if r < gameBoard.count-1 && c < gameBoard.count-1 {
                    revealSpace(r+1, c+1)
                }
                if r < gameBoard.count-1 {
                    revealSpace(r+1, c)
                }
                if r > 0 {
                    revealSpace(r-1, c)
                }
            }
        }
    }
    
    mutating func placeFlag(_ index: Int) {
        if(!displayBoard[index].revealed) {
            displayBoard[index].flagPlaced.toggle()
        }
    }
    
    private mutating func revealBombs () {
        for i in displayBoard.indices {
            if(displayBoard[i].isMine) {
                displayBoard[i].revealed = true
                displayBoard[i].content = "💥"
            }
        }
    }
    
    
    mutating func reset () {
        let newGame = Board(gameBoard.count, numOfMines)
        gameBoard = newGame.gameBoard
        displayBoard = newGame.displayBoard
        bombRevealed = false;
    }
    
    mutating func gameWon () -> Bool {
        for i in displayBoard.indices {
            if displayBoard[i].minesAdjacent > 0 && !displayBoard[i].revealed {
                return false
            }
        }
        return true
    }
    
    init(_ boardDimension: Int, _ numOfMines: Int) {
        self.gameBoard = Array(repeating: Array(repeating: Space(content: "", isMine: false, id: 0, row: 0, col: 0), count: boardDimension), count: boardDimension)
        self.numOfMines = numOfMines
        self.displayBoard = []
        
        // initialize id of board spaces
        var id = 0
        for r in gameBoard.indices {
            for c in gameBoard[r].indices {
                gameBoard[r][c].row = r
                gameBoard[r][c].col = c
                gameBoard[r][c].id = id
                id += 1
            }
        }
        
        var minesPlaced = 0
        // place mines
        while minesPlaced < numOfMines {
            let randRow = Int.random(in: 0...gameBoard.count-1)
            let randCol = Int.random(in: 0...gameBoard[0].count-1)
            // place mine if space is not a mine
            if(!gameBoard[randRow][randCol].isMine) {
                gameBoard[randRow][randCol].content = "💣"
                gameBoard[randRow][randCol].isMine = true
                minesPlaced += 1
            }
        }
        
        // initialize spaces with number of mines
        for r in gameBoard.indices {
            for c in gameBoard[r].indices {
                if !gameBoard[r][c].isMine {
                    var minesNearby = 0
                    if c < gameBoard[r].count-1 && gameBoard[r][c+1].isMine {
                        minesNearby += 1
                    }
                    if c > 0 && gameBoard[r][c-1].isMine {
                        minesNearby += 1
                    }
                    if r > 0 && c < gameBoard[r].count-1 && gameBoard[r-1][c+1].isMine {
                        minesNearby += 1
                    }
                    if r > 0 && c > 0 && gameBoard[r-1][c-1].isMine {
                        minesNearby += 1
                    }
                    if r < gameBoard.count-1 && c > 0 && gameBoard[r+1][c-1].isMine {
                        minesNearby += 1
                    }
                    if r < gameBoard.count-1 && c < gameBoard.count-1 && gameBoard[r+1][c+1].isMine{
                        minesNearby += 1
                    }
                    if r < gameBoard.count-1 && gameBoard[r+1][c].isMine {
                        minesNearby += 1
                    }
                    if r > 0 && gameBoard[r-1][c].isMine {
                        minesNearby += 1
                    }
                    if minesNearby > 0 {
                        gameBoard[r][c].minesAdjacent = minesNearby
                        gameBoard[r][c].content = String(minesNearby)
                    }
                }
            }
        }
        
        for r in gameBoard.indices {
            for c in gameBoard[r].indices {
                displayBoard.append(gameBoard[r][c])
            }
        }
    }
}
