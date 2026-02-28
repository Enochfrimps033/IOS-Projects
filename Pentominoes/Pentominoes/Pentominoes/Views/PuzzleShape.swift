//
//  Untitled.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/27/26.
//

import SwiftUI

struct PuzzleShape: Shape {
    let puzzle: PuzzleOutline
    let offsetX: Int
    let offsetY: Int
    let blockSize: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        for outline in puzzle.outlines {
            guard let first = outline.first else { continue }

            path.move(to: CGPoint(
                x: CGFloat(first.x + offsetX) * blockSize,
                y: CGFloat(first.y + offsetY) * blockSize
            ))

            for p in outline.dropFirst() {
                path.addLine(to: CGPoint(
                    x: CGFloat(p.x + offsetX) * blockSize,
                    y: CGFloat(p.y + offsetY) * blockSize
                ))
            }

            path.closeSubpath()
        }

        return path
    }
}
