//
//  AllPossibleWords.swift
//  Lionspell
//
//  Created by Haley Parker on 2/13/26.
//

//
// when the user click the hint buttin
//words will come upo there will be a navigation arrow to bring it to this page where its a list of sall words 
import SwiftUI

struct  AllPossibleWordsView: View{
    @Environment(GameManager.self) private var GM
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View{
        ZStack{
            BackgroundView().ignoresSafeArea()
            
            VStack(spacing:12){
                
                HStack {
                    Button {dismiss()} label:{
                        HStack(spacing: 8){
                        }
                        .foregroundStyle(.white.opacity(0.85))
                    }
                    
                    Spacer()
                    Text("All Possible Words")
                        .font(.system(size: 14, weight:.bold,design:.rounded))
                        .foregroundStyle(.yellow)
                    
                    Spacer()
                    
                    Color.clear.frame(width:60,height:1)
                }
                .padding(.horizontal)
                
                ScrollView{
                    LazyVStack(spacing: 8){
                        ForEach(GM.scramble.legalWords.sorted(),id: \.self){w in
                            Text(w.uppercased())
                                .font(.system(size:14,weight:.semibold,design:.rounded))
                                .foregroundStyle(.white.opacity(0.85))
                                .frame(maxWidth: .infinity,alignment:.leading )
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                            
                        }
                    }
                    
                    .padding(.horizontal)
                }
                
            }
            
            
        }
    }
    
    
}
