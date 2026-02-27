//
//  PuzzlethumbnailButton.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/25/26.
//

import SwiftUI

struct PuzzleThumbnailButton: View {
    let puzzle: PuzzleOutline
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // background grid-ish look
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: isSelected ? 3 : 1)

                // TEMP: just show puzzle name (replace with real thumbnail drawing next)
                Text(puzzle.name)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .padding(6)
            }
            .frame(width: 80, height: 80)
        }
        .buttonStyle(.plain)
    }
}
