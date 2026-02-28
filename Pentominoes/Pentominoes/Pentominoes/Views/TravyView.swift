//
//  TravyView.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/27/26.
//

import SwiftUI

struct TrayView: View {
    let pieces: [Piece]
    let boardSize: Int
    let blockSize: CGFloat

    let draggedPieceID: UUID?
    let dragTranslation: CGSize

    let onDragChanged: (UUID, CGSize, CGPoint) -> Void
    let onDragEnded: (UUID, CGPoint) -> Void
    let onRotate: (UUID) -> Void
    let onMirror: (UUID) -> Void

    var body: some View {
        ZStack {
            ForEach(pieces) { piece in
                PieceView(
                    piece: piece,
                    blockSize: blockSize,

                    boardSize: boardSize,
                    isDragging: piece.id == draggedPieceID,
                    extraX: -200
                )
                .offset(piece.id == draggedPieceID ? dragTranslation : .zero)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            onDragChanged(piece.id, value.translation, value.startLocation)
                        }
                        .onEnded { value in
                            onDragEnded(piece.id, value.location)
                        }
                )
                .onTapGesture { onRotate(piece.id) }
                .onLongPressGesture(minimumDuration: 0.4) { onMirror(piece.id) }
            }
        }
    }
}
