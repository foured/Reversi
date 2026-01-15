//
//  GameView.swift
//  Reversi
//
//  Created by Иван Топоров on 15.01.2026.
//


import SwiftUI

enum MyError: Error {
    case SuperError
}

struct GameView: View {
    @State var board: Board = Board()
    @State var currentTurn = Game.Player.Black
    @State var showNoMoveText: Bool = false
    
    @State var gameFinished = false
    @State var winner = Game.Winner.Draw
    
    let mode: Game.Mode
    let onGoBack: () -> Void
    
    static var DEBUG_COUNT = 0
    
    var body: some View {
        VStack {
            Button() {
                board = Board()
                onGoBack()
            } label: {
                BoldText("Назад в меню")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
            )
            
            if !gameFinished {
                VStack {
                    if showNoMoveText {
                        BoldText("Нет ходов, игрок ходит повторно")
                    }
                    HStack {
                        BoldText("Ход")
                        switch currentTurn {
                        case .Red:
                            BoldText("красного")
                                .foregroundStyle(.red)
                        case .Black:
                            BoldText("чёрного")
                                .foregroundStyle(.blackPlayer)
                        }
                    }
                }
                Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                    ForEach(0..<Board.Side, id: \.self) { row in
                        GridRow {
                            ForEach(0..<Board.Side, id: \.self) { col in
                                CellView(type: board[row][col]) {
                                    onCellClick(pos: Pos(col, row))
                                }
                            }
                        }
                    }
                }
            } else {
                switch winner {
                case .Red:
                    WinnerText("красный", .red)
                case .Black:
                    WinnerText("черный", .blackPlayer)
                case .Draw:
                    BoldText("Ниья!")
                }
            }
            HStack {
                let (red, black) = board.countRedAndBlack()
                cellsCounter(red, .red)
                cellsCounter(black, .blackPlayer)
            }
        }
        .padding()
    }
    
    func onCellClick(pos: Pos) {
        if Game.IsAvaliableMove(move: pos, turn: currentTurn, board: board) {
            makeMove(pos: pos)
        }
    }
    
    func makeMove(pos: Pos) {
        withAnimation() {
            board.appendMove(move: pos, turnColor: currentTurn.toCellType())
        }
        
        let (red, black) = board.countRedAndBlack()
        
        guard red > 0 else {
            // game over
            winner = .Black
            gameFinished = true
            return
        }
        
        guard black > 0 else {
            // game over
            winner = .Red
            gameFinished = true
            return
        }
        
        let nextPlayer = currentTurn.flip()
        if let _ = Game.GetPossibleMoves(for: nextPlayer, on: board) {
            showNoMoveText = false
            currentTurn = nextPlayer
        } else if let _ = Game.GetPossibleMoves(for: currentTurn, on: board) {
            showNoMoveText = true
        }
        else {
            // game over
            if red > black {
                winner = .Red
            } else if black > red {
                winner = .Black
            } else {
                winner = .Draw
            }
            
            gameFinished = true
            return
        }
        
        if currentTurn == .Red && (mode == .Noob || mode == .Pro) {
            Self.DEBUG_COUNT += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                guard let aiMove = (mode == .Noob
                                    ? GameAI.FindBestMove(board: board, turn: .Red)
                                    : GameAI.AnalyzeAndFindBestMove(board: board, turn: .Red))
                else {
                    print("У компьютера нет доступных ходов")
                    return
                }
                
                makeMove(pos: aiMove)
            }
        }
        
    }
    
    
    @ViewBuilder
    func cellsCounter(_ count: Int, _ color: Color) -> some View {
        HStack {
            Circle()
                .frame(width: CellView.CircleRadius)
                .foregroundStyle(color)
            BoldText("-\(count)")
        }
        .padding()
    }
    
    @ViewBuilder
    func WinnerText(_ text: String, _ color: Color) -> some View {
        HStack {
            BoldText("Победил")
            BoldText(text)
                .foregroundStyle(color)
        }
        .padding()
    }
}
