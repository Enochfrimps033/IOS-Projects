//
//  ContentView.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/24/26.
//

import SwiftUI

struct ContentView: View {
    @State private var gameManager = GameManager()

    @State private var draggedPieceID: UUID? = nil
    @State private var dragTranslation: CGSize = .zero
    @State private var grabOffset: CGSize = .zero

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 12) {

                thumbnailColumn(indices: leftIndices)
                    .frame(width: 120)

                BoardView(
                    puzzle: gameManager.selectedPuzzle,
                    boardSize: gameManager.boardSize,
                    blockSize: gameManager.blockSize,
                    pieces: gameManager.pieces,
                    draggedPieceID: draggedPieceID,
                    dragTranslation: dragTranslation,
                    onDragChanged: { id, translation, startLocation in
                        if draggedPieceID != id {
                            draggedPieceID = id
                            grabOffset = CGSize(
                                width: startLocation.x.truncatingRemainder(dividingBy: gameManager.blockSize),
                                height: startLocation.y.truncatingRemainder(dividingBy: gameManager.blockSize)
                            )
                        }
                        dragTranslation = translation
                    },
                    onDragEnded: { id, dropLocation in
                        guard let idx = gameManager.pieces.firstIndex(where: { $0.id == id }) else { return }
                        let b = gameManager.blockSize

                        let targetCellX = Int(round((dropLocation.x - grabOffset.width) / b))
                        let targetCellY = Int(round((dropLocation.y - grabOffset.height) / b))

                        withAnimation(.easeInOut(duration: 0.15)) {
                            gameManager.pieces[idx].position.x = targetCellX
                            gameManager.pieces[idx].position.y = targetCellY
                        }

                        draggedPieceID = nil
                        dragTranslation = .zero
                        grabOffset = .zero
                    },
                    onRotate: { id in gameManager.rotatePiece(id: id) },
                    onMirror: { id in gameManager.mirrorPiece(id: id) }
                )

                thumbnailColumn(indices: rightIndices)
                    .frame(width: 120)
            }

            controls
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }

    private var leftIndices: [Int] {
        Array(gameManager.puzzles.indices.prefix(gameManager.puzzles.count / 2))
    }

    private var rightIndices: [Int] {
        Array(gameManager.puzzles.indices.dropFirst(gameManager.puzzles.count / 2))
    }

    private func thumbnailColumn(indices: [Int]) -> some View {
        VStack(spacing: 12) {
            ForEach(indices, id: \.self) { i in
                PuzzleThumbnailButton(
                    puzzle: gameManager.puzzles[i],
                    isSelected: gameManager.selectedPuzzleIndex == i
                ) {
                    gameManager.selectedPuzzleIndex = i
                    gameManager.reset()
                }
            }
            Spacer()
        }
    }

    private var controls: some View {
        HStack {
            Button {
                gameManager.reset()
            } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(PillButtonStyle(
                colors: [Color.orange, Color.pink],
                glow: .orange
            ))

            Spacer()

            Button {
                gameManager.solve()
            } label: {
                Label("Solve", systemImage: "sparkles")
            }
            .buttonStyle(PillButtonStyle(
                colors: [Color.teal, Color.blue],
                glow: .teal
            ))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

#Preview {
    ContentView()
}
