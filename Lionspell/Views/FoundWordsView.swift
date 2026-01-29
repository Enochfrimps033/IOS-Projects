//
//  FoundWordsView.swift
//  Lionspell
//
//  Created by Haley Parker on 1/28/26.
//
import SwiftUI
struct   FoundWordsView:View{
    let words:[String]
    
    var body: some View {
        VStack(alignment:.leading ,spacing:10){
            
            
            
            HStack(spacing:8){
                Image(systemName:"checkmark.seal.fill")
                    .font(.system(size:12,weight:.bold))
                    .foregroundStyle(.yellow.opacity(0.6))
                Text("FOUND WORDS")
                    .font(.system(size: 12,weight: .bold,design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                
            }
                
                RoundedRectangle(cornerRadius:18)
                    .fill(Color.white.opacity(0.12))
                    .frame(height:72)
                    .overlay(
                    Group{
                        
                        if words.isEmpty{
                            Text(" No words yet").font(.system(size: 16,weight:.semibold,design:.rounded))
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.vertical,10)
                        }else{
                            ScrollView(.horizontal,showsIndicators:false){
                                HStack(spacing:12){
                                    ForEach(words,id: \.self){
                                        w in Wordtextbox(text: w)
                                    }
                                }
                                
                                
                                
                                .padding(.horizontal,2)
                            }
                        }
                    }
                )
            }
        }
        
    }
    
    struct Wordtextbox:View{
        let text:String
        
        var body: some View {
            Text(text.uppercased())
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal,14)
                .padding(.vertical,10)
                .background(Capsule().fill(Color.white.opacity(0.20)))
            
        }
    }

