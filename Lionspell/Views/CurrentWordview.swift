//
//  CurrentWordview.swift
//  Lionspell
//
//  Created by Haley Parker on 1/28/26.
//

import SwiftUI
struct CurrentWordView: View {
    let word: String
    let minslotCount: Int

    
    init(word:String,minslotCount:Int=5){
        self.word=word
        self.minslotCount=minslotCount
    }
    var body: some View {
        let letters=Array(word.uppercased())
        let slotCount=max(self.minslotCount,letters.count)
        
        VStack(spacing:10){
            Text("BUILD YOUR WORD")
                .font(.system(size:12,weight:.bold,design: .rounded))
                .foregroundStyle(Color.white.opacity(0.56))
        
        
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.18))
            .frame(height:66)
            .overlay(
                HStack(spacing:10){
                    ForEach(0..<slotCount, id: \.self){i in
                        let chars=Array(word.uppercased())
                        let letter=i<chars.count ? String(chars[i]) : " "
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.10))
                            .frame(width:42,height:42)
                            .overlay(
                                Text(letter)
                                    .font(.system(size:22,weight:.bold,design:.rounded))
                                    .foregroundStyle(.white)
                            )
                    }
                }
                    .padding(.horizontal,14)
                    
            )
      
           
    }
}

}
