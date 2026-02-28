//
//  PieceView.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/27/26.
//

import SwiftUI


struct PieceView: View {
    let piece: Piece
    let blockSize: CGFloat
    let boardSize: Int
    let isDragging: Bool
    let extraX: CGFloat

    var body: some View {
        let shape = PentominoShape(
            outline: piece.outline,
            position: piece.position,
            blockSize: blockSize,
            extraX: extraX
        )

        ZStack {
            
            shape.fill(.blue.opacity(0.6))

            GridShape(boardSize: boardSize, blockSize: blockSize)
                .stroke(lineWidth: 1)
                .offset(x: extraX, y:0)
                .clipShape(shape)

           
            shape.stroke(lineWidth: 2)
        }
        .scaleEffect(isDragging ? 1.2 : 1.0)
        .animation(.easeInOut(duration: 0.12), value: isDragging)
        .contentShape(shape)
    }
}
