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
    private var puzzlePath: Path {
        
        Path { path in
           
            for outline in puzzle.outlines {
                guard let first = outline.first else{continue}
                
                path.move(to:CGPoint(x:  CGFloat(first.x + puzzleOffsetX) * blockSize, y:   CGFloat(first.y + puzzleOffsetY) * blockSize))
            
                
                for p in outline.dropFirst() {
                    path.addLine(to: CGPoint(
                        x: CGFloat(p.x +  puzzleOffsetX ) * blockSize,
                        y: CGFloat(p.y + puzzleOffsetY) * blockSize
                    ))
                }
                
                path.closeSubpath()
            }
        }
    }
    
    private func piecePath(for piece: Piece) -> Path {
        Path{ path in
            let point = piece.outline.outline
            guard let first = point.first else{return}
            
            
            let positionX = piece.position.x
            let positionY = piece.position.y
            let horizontalOffset: CGFloat = -200
            path.move(to: CGPoint(
                x: CGFloat(first.x + positionX ) * blockSize + horizontalOffset ,
                y: CGFloat( first.y + positionY ) * blockSize
                ))
            for p in point.dropFirst(){
                path.addLine(to: CGPoint(
                    x: CGFloat(p.x + positionX) * blockSize + horizontalOffset, 
                    y: CGFloat(p.y + positionY ) * blockSize
                    ))

            }
            path.closeSubpath()

    }
    
    }
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .stroke()
            Path{ path in
                for i in 0...boardSize{
                    let x = CGFloat(i) * blockSize
                    let y = CGFloat(i) * blockSize
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: side))
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: side, y: y))
                    
                    
                    
                }
                
            }
            
            
            .stroke(lineWidth: 1)
            puzzlePath.fill(.gray.opacity(0.35))
            puzzlePath.stroke(.red, lineWidth: 3)
            ForEach(pieces) {piece in
                piecePath(for: piece)
                    .stroke(lineWidth: 2)
                
            }
//            ForEach(pieces.filter { $0.position.y < boardSize }) { piece in
//                piecePath(for: piece).stroke(lineWidth: 2)
//            }
        }
        
       
            .frame(width: side, height:side)
        }
    }

