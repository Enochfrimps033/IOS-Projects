//
//  PentominoViewModel.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/24/26.
//

import SwiftUI
@Observable
class GameManager {
    
    @ObservationIgnored let blockSize: CGFloat = 40
    @ObservationIgnored let boardSize: Int = 14
    
    var selectedPuzzleIndex: Int = 0
    
    var pieces: [Piece] = []
    var puzzles: [PuzzleOutline] = []
    var solutions: [String: [String: Position]] = [:]
    
    var draggedPieceID: UUID?
    var dragTranslation: CGSize = .zero
    var draggedPieceOriginalPosition: Position?
    var selectedPuzzle: PuzzleOutline {
        puzzles[selectedPuzzleIndex]
    }
    private var pentominoOutlines: [PentominoOutline] = []
    
    init() {
        loadData()
        print(puzzles.count)

        buildPieces()
        setInitialPiecePositions()
    }
    
    func loadData() {
        let store = PentominoDataStore()
        puzzles = store.puzzles
        solutions = store.solutions
        pentominoOutlines = store.pentominoOutlines
    }
    
    func buildPieces(){
        
        for  outline in pentominoOutlines{
            let newPiece = Piece(
                name: outline.name,
                outline: outline,
                position: Position(x: 0, y: 0, orientation: .up))
            pieces.append(newPiece)
            
        }
    }
    
    func setInitialPiecePositions(){
        for Eachpiece in 0..<pieces.count{
            let col = Eachpiece % 4
            let row = Eachpiece / 4
            
            let  x = 1 + col * 6
            
            let  y = 16 + row * 6
            
            pieces[Eachpiece].position = Position(x: x, y: y, orientation: .up)
            
        }
        
    }
    func reset (){
        setInitialPiecePositions()
    }
    
    
    func solve(){
        let puzzlename = puzzles[selectedPuzzleIndex].name
        let SolutiontoPuzzle = solutions[puzzlename]
        
        for i in 0..<pieces.count{
            let currentpiecename = pieces[i].name
            let matchingSolution = SolutiontoPuzzle?[currentpiecename]
            if let  pos = matchingSolution{
                var updated = pieces
                updated[i].position = pos
                pieces = updated

                
            }

            }
        }
    }

