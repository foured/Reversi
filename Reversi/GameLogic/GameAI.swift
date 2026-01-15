//
//  GameAI.swift
//  Reversi
//
//  Created by Иван Топоров on 15.01.2026.
//

class GameAI {
    static func EvaluateMove(move: Pos, board: Board, turn: Game.Player) -> Double {
        var eval = Board.SS_at(move)
        
        let closures = board.getClosures(move: move, turnColor: turn.toCellType())
        for cl in closures {
            eval += Board.Si_at(cl)
        }
        
        return eval
    }
    
    static func FindBestMove(board: Board, turn: Game.Player) -> Optional<Pos> {
        let avaliableMoves = Game.GetPossibleMoves(for: turn, on: board)
        guard let avaliableMoves else {
            return nil
        }
        
        var bestMove: Optional<Pos> = nil
        var bestScore: Double = -Double.greatestFiniteMagnitude
        for move in avaliableMoves {
            let ev = EvaluateMove(move: move, board: board, turn: turn)
            if ev > bestScore {
                bestMove = move
                bestScore = ev
            }
        }
        
        if bestMove == nil {
            return avaliableMoves.randomElement()
        }
        
        return bestMove
    }
    
    static func AnalyzeAndFindBestMove(board: Board, turn: Game.Player) -> Optional<Pos> {
        let avaliableMoves = Game.GetPossibleMoves(for: turn, on: board)
        guard let avaliableMoves else {
            return nil
        }
        
        
        
        var bestMove: Optional<Pos> = nil
        var bestScore: Double = -Double.greatestFiniteMagnitude
        
        for move in avaliableMoves {
            var ev = EvaluateMove(move: move, board: board, turn: turn)
            var board_copy = board
            board_copy.appendMove(move: move, turnColor: turn.toCellType())
            let enemy_best = FindBestMove(board: board_copy, turn: turn.flip())
            if let enemy_best {
                ev -= EvaluateMove(move: enemy_best, board: board_copy, turn: turn.flip())
                if ev > bestScore {
                    bestMove = move
                    bestScore = ev
                }
            }
        }
        
        guard bestMove != nil else {
            return FindBestMove(board: board, turn: turn)
        }
        
        return bestMove
    }
}
