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
                
               
                
                    ScoreView(score:GM.Score)
                    
                       
                    
                    
                }
                .padding(.horizontal)
            
            
                FoundWordsView(words:GM.foundWords)
            
                CurrentWordView(word:GM.currentword)
                Letterpad(letters:GM.cramble.letters, highlightcenter: GM.scramble.requiredLetter)
            
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
    
}

struct BackgroundView:View{
    
    var body:some View {
        LinearGradient(colors:[Color(red:0.06,green:0.18,blue:0.36),Color(red:0.2,green:0.10,blue:0.22)],startPoint: .topLeading, endPoint: .bottomLeading)
    
}
}


    struct HeaderTitle:View{
        var body: some View {
            Text("Lion Spell")
                .font(.system(size:25,weight :.bold,design:.rounded))
                .foregroundStyle(LinearGradient(colors: [.white,Color(white:0.80)],
                                                startPoint: .topLeading, endPoint: .bottomLeading ))
            
                .shadow(color: .black.opacity(0.2),radius:5,x:0,y:2)
                            
          
            
        }
    }

struct ScoreView:View{
    
    let score:Int
    
    var body: some View {
        HStack{
            Text("Score").font(.system(size:16, weight:.semibold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Text("\(score)")
                .font(.system(size:12, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal,12)
                .padding(.vertical,6)
                .background(Capsule().fill(Color.white.opacity(0.6)))
        }
        .padding(.horizontal,6)
        .padding(.vertical,6)
        .background(RoundedRectangle(cornerRadius: 9).fill(Color.white.opacity(0.1)))
        
    
}
}
struct   FoundWordsView:View{
    let words:[String]
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing:16){
                if words.isEmpty{
                    Wordtextbox(text:" No words yet").opacity(0.7)
                }else{
                    ForEach(words,id:\.self){w in Wordtextbox(text:w)
                    }
                    
                }
            }
            .padding(.horizontal,2)
        }
    }
}

struct Wordtextbox:View{
    let text:String
    
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(Color.white)
            .padding(.horizontal,14)
            .padding(.vertical,10)
            .background(Capsule().fill(Color.white.opacity(0.6))
        )
        
    }
}

struct CurrentWordView: View {
    let word: String

    var body: some View {
        Text(word.isEmpty ? " " : word)
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.18))
            )
    }
}

struct Letterpad: View {
    let letters: [String]
    let highlightcenter: Int
    
    var body: some View {
        HStack(spacing: 14) {
            HStack(spacing: 10) {
                ForEach(letters.indices, id:\.self){ i in
                    LetterButton(letter: letters[i],isRequired: i==highlightcenter)
                    
                }
            }
        }
            .padding(.vertical, 12)
        }
    }
    
    struct LetterButton: View {
        let letter: String
        let isRequired: Bool
        
        var body: some View {
            Button {
            } label: {
                Text(letter)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(isRequired ? .black : .white)
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(isRequired ? Color.yellow : Color.white.opacity(0.20))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.25), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
            }
        }
    }
    
    enum ActionButtonStyle {
        case neutral
        case primary
    }
    
    struct ActionButton: View {
        let title: String
        let systemImage: String
        let style: ActionButtonStyle
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Label(title, systemImage: systemImage)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(style == .primary ? Color.green.opacity(0.55) : Color.white.opacity(0.18))
                    )
            }
        }
    }

