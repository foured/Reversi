//
//  Game.swift
//  Reversi
//
//  Created by Иван Топоров on 13.01.2026.
//


class Game {
    enum Player: Int {
        case Red = 1
        case Black = 2
        
        func flip() -> Player {
            switch self {
            case .Red:
                return .Black
            case .Black:
                return .Red
            }
        }
        
        mutating func flipInsert() {
            self = self.flip()
        }
        
        func toCellType() -> Board.CellType {
            switch self {
            case .Red:
                return Board.CellType.Red
            case .Black:
                return Board.CellType.Black
            }
        }
    }
    
    enum Mode {
        case Player
        case Noob
        case Pro
    }
    
    enum Winner {
        case Red
        case Black
        case Draw
    }
    
    // return not null if not empty
    static func GetPossibleMoves(for player: Player, on board: Board) -> Optional<Set<Pos>> {
        var avaliable: [Pos: Set<Pos>] = [:]
        for i in 0..<Board.Side {
            for j in 0..<Board.Side {
                if board[i][j].cmp(player.flip()) {
                    let cellPos = Pos(j, i)
                    avaliable[cellPos] = board.getSurround(cellPos, toSearch: .Empty)
                }
            }
        }
        
        guard !avaliable.isEmpty else {
            return nil
        }
        
        var moves = Set<Pos>()
        for (tCell, pMoves) in avaliable {
            for pCell in pMoves {
                if board.checkLine(move: pCell, target: tCell) {
                    moves.insert(pCell)
                }
            }
        }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
    
    static func IsAvaliableMove(move: Pos, turn: Player, board: Board) -> Bool {
        let surround = board.getSurround(move, toSearch: turn.flip().toCellType())
        for tCell in surround {
            if board.checkLine(move: move, target: tCell) {
                return true
            }
        }
        
        return false
    }
}
