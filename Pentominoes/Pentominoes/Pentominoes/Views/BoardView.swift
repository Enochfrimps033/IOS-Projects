//
//  Untitled 2.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/25/26.
//
import SwiftUI
struct BoardView: View {
    let puzzle: PuzzleOutline
    let boardSize: Int
    let blockSize: CGFloat
    let pieces: [Piece]

    let draggedPieceID: UUID?
    let dragTranslation: CGSize

    let onDragChanged: (UUID, CGSize, CGPoint) -> Void
    let onDragEnded: (UUID, CGPoint) -> Void

    let onRotate: (UUID) -> Void
    let onMirror: (UUID) -> Void

    private var side: CGFloat {
        CGFloat(boardSize) * blockSize
    }
    private var puzzleBounds: (minX: Int, maxX: Int, minY: Int, maxY: Int) {
        var minX = Int.max, maxX = Int.min
        var minY = Int.max, maxY = Int.min

        for outline in puzzle.outlines {
            for p in outline {
                minX = min(minX, p.x)
                maxX = max(maxX, p.x)
                minY = min(minY, p.y)
                maxY = max(maxY, p.y)
            }
        }
        return (minX, maxX, minY, maxY)
    }

    private var puzzleOffsetX: Int {
        let b = puzzleBounds
        let width = b.maxX - b.minX
        return (boardSize - width) / 2 - b.minX
    }

    private var puzzleOffsetY: Int {
        let b = puzzleBounds
        let height = b.maxY - b.minY
        return (boardSize - height) / 2 - b.minY
    }
   
    private var puzzleShape: PuzzleShape {
        PuzzleShape(
            puzzle: puzzle,
            offsetX: puzzleOffsetX,
            offsetY: puzzleOffsetY,
            blockSize: blockSize
        )
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke()

            GridShape(boardSize: boardSize, blockSize: blockSize)
                .stroke(lineWidth: 1)

            puzzleShape
                .fill(.gray.opacity(0.35), style: FillStyle(eoFill: true))

            puzzleShape
                .stroke(.red, lineWidth: 3)

            ForEach(pieces) { piece in
                ZStack {
                    PieceView(
                        piece: piece,
                        blockSize: blockSize,
                        boardSize: boardSize,
                        isDragging: false,
                        extraX: -200
                    ).onTapGesture {
                        onRotate(piece.id)
                    }
                    .onLongPressGesture(minimumDuration: 0.4) {
                        onMirror(piece.id)
                    }
                    .scaleEffect(piece.id == draggedPieceID ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.12), value: piece.id == draggedPieceID)
                }
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
            }
        }
        .frame(width: side, height: side)
    }
    }

