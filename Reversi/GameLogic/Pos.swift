//
//  Pos.swift
//  Reversi
//
//  Created by Иван Топоров on 13.01.2026.
//


struct Pos: Hashable {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

func +(lhs: Pos, rhs: Pos) -> Pos {
    Pos(lhs.x + rhs.x, lhs.y + rhs.y)
}

func -(lhs: Pos, rhs: Pos) -> Pos {
    Pos(lhs.x - rhs.x, lhs.y - rhs.y)
}

func *(lhs: Pos, rhs: Int) -> Pos {
    Pos(lhs.x * rhs, lhs.y * rhs)
}

func +=(lhs: inout Pos, rhs: Pos) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}
