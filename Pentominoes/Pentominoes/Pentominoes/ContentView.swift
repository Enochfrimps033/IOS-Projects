//
//  ContentView.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/24/26.
//

import SwiftUI
struct ContentView: View {
    @State private var gameManager = GameManager()
    
    var body: some View {
//        GeometryReader { geo in
//            let availableWidth = geo.size.width - 120 - 120 - 100
//            let availableHeight = geo.size.height - 180
//            
//            let side = min(availableWidth, availableHeight)
//            let block = side / CGFloat(gameManager.boardSize)
//            
            VStack(spacing: 12){
                Spacer(minLength: 0)
                HStack(alignment:.top, spacing :12) {
                    
                    thumbnailColumn(indices: leftIndices).frame(width: 120)
                    
                    BoardView(
                        puzzle: gameManager.selectedPuzzle ,
                        boardSize: gameManager.boardSize,
                        blockSize: gameManager.blockSize,
                        pieces: gameManager.pieces
                    )
                    thumbnailColumn(indices: rightIndices).frame(width: 120)
                }
                controls
                Spacer(minLength: 0)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            .padding()
        
    }
    
    private var leftIndices:[Int]{
        Array(gameManager.puzzles.indices.prefix(gameManager.puzzles.count / 2))
        
    }
    
    
    private var rightIndices:[Int]{
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
    
        
        
       private  var boardPlaceholder: some View {
            let side = CGFloat(gameManager.boardSize)*(gameManager.blockSize)
            
             return RoundedRectangle(cornerRadius: 12)
                .stroke()
                .frame(width: side, height: side)
                .overlay(
                    Text("Board goes here")
                )
        }
        
        
      private  var controls: some View{
            HStack(spacing:12){
                Button("Reset"){
                    gameManager.reset()
                }
                Button("Solve"){
                    gameManager.solve()
                
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
