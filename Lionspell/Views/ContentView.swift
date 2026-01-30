//
//  ContentView.swift
//  Lionspell
//
//  Created by Enoch Frimpong on 1/22/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(GameManager.self) private var GM
//    @State private var score: Int=0
//    @State private var foundwords: [String]=[]
//    @State private var currentword: String=""
//    @State private var scramble=Scramble()// SOT
    
    // prof said group view put in different files
    var body: some View {
        ZStack{
            BackgroundView()
                .ignoresSafeArea()

            
            VStack(spacing:20){
                
            
                HStack{
                    VStack(alignment: .leading,spacing: 2 ){
                        HeaderTitle()
                    
                    Text("Nittany Word Challenge ").font(.caption).foregroundStyle(.white.opacity(0.6))
                }
                
               
                
                    ScoreView(score: GM.Score)
                    
                       
                    
                    
                }
                .padding(.horizontal)
            
            
                FoundWordsView(words:Array(GM.foundWords).sorted())
            
                CurrentWordView(word:GM.currentWord)
                
                Text(GM.message)
                    .font(.system(size:14,weight:.semibold,design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(maxWidth:.infinity,alignment:.center)
                    .padding(.top,4)
            
                
                Letterpad(letters:GM.scramble.letters, highlightcenter: GM.scramble.requiredLetter)
            
            HStack(spacing:14){
                ActionButton(title:"Delete",systemImage:"delete.left",style:.neutral){
                    GM.deleteLetter()
                }
                
                ActionButton(title:"Submit",systemImage:"checkmark.circle",style:.primary){
                    GM.submitWord()
                    
                }
                
            }
            
            Spacer(minLength: 10)
            
            HStack(spacing:14){
                ActionButton(title:"Shuffle",systemImage:"shuffle",style:.neutral){
                    
                }
                ActionButton(title:"New Game",systemImage:"arrow.counterclockwise",style:.neutral){
                    GM.startNewGame()
                }
            }
            
        }
        .padding()
        }
    }

}
#Preview {
    
        ContentView()
        .environment(GameManager())
    
}


