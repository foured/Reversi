//
//  ContentView.swift
//  Reversi
//
//  Created by Иван Топоров on 13.01.2026.
//

import SwiftUI

enum GameState {
    case Menu
    case InGame
    
    func flip() -> GameState {
        switch self {
        case .Menu:
            return .InGame
        case .InGame:
            return .Menu
        }
    }
}

struct ContentView: View {
    @State var gameState: GameState = .Menu
    @State var gameMode: Game.Mode = .Player
    
    var body: some View {
        switch gameState {
        case .Menu:
            VStack(spacing: 20) {
                BoldText("Реверси")

                VStack(spacing: 14) {
                    MenuButton(
                        title: "Игра с человеком",
                        subtitle: "Локальная партия",
                        accent: .blue
                    ) {
                        startGame(.Player)
                    }

                    MenuButton(
                        title: "Компьютер — новичок",
                        subtitle: "Простая стратегия",
                        accent: .green
                    ) {
                        startGame(.Noob)
                    }

                    MenuButton(
                        title: "Компьютер — продвинутый",
                        subtitle: "Анализ ходов",
                        accent: .red
                    ) {
                        startGame(.Pro)
                    }
                }
            }
            .padding()
        case .InGame:
            GameView(mode: gameMode) {
                withAnimation() {
                    gameState = gameState.flip()
                }
            }
        }
    }
    
    func startGame(_ mode: Game.Mode) {
        gameMode = mode
        withAnimation() {
            gameState = gameState.flip()
        }
    }

}

#Preview {
    ContentView()
}
