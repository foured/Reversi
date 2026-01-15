//
//  MenuButton.swift
//  Reversi
//
//  Created by Иван Топоров on 15.01.2026.
//

import SwiftUI

struct MenuButton: View {

    let title: String
    let subtitle: String
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(accent)
            .cornerRadius(14)
            .shadow(color: accent.opacity(0.3), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
    }
}
