//
//  Board.swift
//  Reversi
//
//  Created by Иван Топоров on 13.01.2026.
//

struct Board {
    static let Side = 8
    
    static let Si_w: [[Double]] = [
        [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0],
        [2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0],
        [2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0],
        [2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0],
        [2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0],
        [2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0],
        [2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0],
        [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]
    ]
    
    static let SS_w: [[Double]] = [
        [0.8, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.8],
        [0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4],
        [0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4],
        [0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4],
        [0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4],
        [0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4],
        [0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4],
        [0.8, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.8]
    ]
    
    enum CellType: Int {
        case Empty = 0
        case Red = 1
        case Black = 2
        
        func flip() -> CellType {
            switch self {
            case .Empty:
                return .Empty
            case .Red:
                return .Black
            case .Black:
                return .Red
            }
        }
        
        func cmp(_ player: Game.Player) -> Bool {
            return self.rawValue == player.rawValue
        }
    }
    
    var matrix: [[CellType]]
    
    init() {
        matrix = Array(
            repeating: Array(
                repeating: .Empty,
                count: Self.Side
            ),
            count: Self.Side
        )
        
        matrix[3][3] = .Red
        matrix[3][4] = .Black
        matrix[4][3] = .Black
        matrix[4][4] = .Red
    }
    
    subscript(row: Int) -> [CellType] {
        get {
            matrix[row]
        }
        set {
            matrix[row] = newValue
        }
    }
    
    subscript(_ pos: Pos) -> CellType {
        get {
            matrix[pos.y][pos.x]
        }
        set {
            matrix[pos.y][pos.x] = newValue
        }
    }
    
    func at(_ pos: Pos) -> CellType {
        return matrix[pos.y][pos.x]
    }
    
    func getSurround(_ pos: Pos, toSearch cellType: CellType) -> Set<Pos> {
        var surround = Set<Pos>()
        for dx in -1...1 {
            for dy in -1...1 {
                let rPos = Pos(
                    Board.clamp(pos.x + dx),
                    Board.clamp(pos.y + dy)
                )
                if at(rPos) == cellType {
                    surround.insert(rPos)
                }
            }
        }
        
        return surround
    }
    
    func checkLine(move: Pos, target: Pos) -> Bool {
        let playerType = at(target).flip()
        let delta = target - move
        var walker = target + delta
        while Board.bounds(walker) {
            if at(walker) == playerType {
                return true
            }
            walker += delta
        }
        return false
    }
    
    func countRedAndBlack() -> (Int, Int) {
        var red = 0
        var black = 0
        for arr in matrix{
            for cell in arr {
                if cell == .Red {
                    red += 1
                } else if cell == .Black {
                    black += 1
                }
            }
        }
        
        return (red, black)
    }
    
    func getClosures(move: Pos, turnColor: CellType) -> Set<Pos> {
        var ret = Set<Pos>()
        let targets = getSurround(move, toSearch: turnColor.flip())
        for target in targets {
            let delta = target - move
            var walker = target + delta
            var chache = [target]
            while Board.bounds(walker) {
                chache.append(walker)
                if at(walker) == turnColor {
                    for chached in chache {
                        ret.insert(chached)
                    }
                }
                walker += delta
            }
        }
        return ret
    }
    
    mutating func appendMove(move: Pos, turnColor: CellType) {
        self[move] = turnColor
        let closures = getClosures(move: move, turnColor: turnColor)
        for cl in closures {
            self[cl] = turnColor
        }
    
    }
    
    static func clamp(_ val: Int) -> Int {
        return max(0, min(Self.Side - 1, val))
    }
    
    static func bounds(_ val: Int) -> Bool {
        return val >= 0 && val < Self.Side
    }
    
    static func bounds(_ pos: Pos) -> Bool {
        return bounds(pos.x) && bounds(pos.y)
    }
    
    static func Si_at(_ pos: Pos) -> Double {
        return Si_w[pos.y][pos.x]
    }
    
    static func SS_at(_ pos: Pos) -> Double {
        return SS_w[pos.y][pos.x]
    }
}
