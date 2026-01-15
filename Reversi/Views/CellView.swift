//
//  CellView.swift
//  Reversi
//
//  Created by Иван Топоров on 13.01.2026.
//

import SwiftUI

struct CellView: View {
    static let SquareSide: CGFloat = 45
    static let CircleRadius: CGFloat = SquareSide - 5
    
    let type: Board.CellType
    let onClick: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(.gray)
                .frame(width: Self.SquareSide, height: Self.SquareSide)
                .onTapGesture {
                    if type == .Empty {
                        onClick()
                    }
                }
            switch type {
            case .Empty:
                EmptyView()
            case .Red:
                Piece(.red)
            case .Black:
                Piece(.black)
            }
        }
    }
    
    @ViewBuilder
    private func Piece(_ color: Color) -> some View {
        Circle()
            .foregroundStyle(color)
            .frame(width: Self.CircleRadius)
            .shadow(color: .white, radius: 5)
        
    }
}
