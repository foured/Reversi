//
//  BoldText.swift
//  Reversi
//
//  Created by Иван Топоров on 15.01.2026.
//

import SwiftUI

struct BoldText: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: 32, weight: .bold, design: .rounded))
    }
}
