//
//  ContentView.swift
//  Lionspell
//
//  Created by Enoch Frimpong on 1/22/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(GameManager.self) private var GM
    @State private var showPreferences=false
//    @State private var score: Int=0
//    @State private var foundwords: [String]=[]
//    @State private var currentword: String=""
//    @State private var scramble=Scramble()// SOT
    
    
    // prof said group view put in different files
    var RequiredValidWord: Bool {
        let required = GM.scramble.letters[GM.scramble.requiredLetter]
        let word = GM.currentWord.lowercased()
        return word.count >= 4 && word.contains(required)
    }
    
    var LightOnDelete: Bool {
        !GM.currentWord.isEmpty
    }

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
                
                .disabled(!LightOnDelete)
                .opacity(LightOnDelete ? 1.0 : 0.3)
                
                
                
                ActionButton(title:"Submit",systemImage:"checkmark.circle",style:.primary){
                    GM.submitWord()
                    
                }

                .disabled(!RequiredValidWord)
                .opacity(RequiredValidWord ? 1.0 : 0.3)
                
                
            }
            Spacer(minLength: 10)
            
                HStack(spacing:14){
                    ActionButton(title:"Shuffle",systemImage:"shuffle",style:.neutral){
                        GM.shuffleLetter()
                        
                    }
                    ActionButton(title:"New Game",systemImage:"arrow.counterclockwise",style:.neutral){
                        GM.startNewGame()
                    }
                    ActionButton(title:"Settings ",systemImage:"gearshape",style:.neutral){
                        showPreferences=true
                    }
                    
                }
        }
        .padding()
        }
        .sheet(isPresented: $showPreferences){
            PreferenceView()
        }
           
    }

}
#Preview {
    
        ContentView()
        .environment(GameManager())
    
}


