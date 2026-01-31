//
//  GenerateValidWord.swift
//  Lionspell
//
//  Created by Haley Parker on 1/23/26.
//

import Foundation

//struct GenerateValidWord{
//    
//    static func FiveUniqueLetters() -> [String]{
//        
//        // reading from json file
//        let all = Words.allWords.englishWords
//        
//        return all.filter {word in
//            // json file is lower case make sure input is lowercase
//            let lower_case=word.lowercased()
//            
//            
//            let unique_char=Set(lower_case)
//            
//            return unique_char.count == 5
//            
//        }
//        
//    }
//}


struct Scramble{
    let letters:[String]
    let requiredLetter: Int
    
    let legalWords: [String]
    
    init(letters:[String],requiredLetter: Int,legalWords:[String] ){
        self.letters=letters
        self.requiredLetter=requiredLetter
        self.legalWords=legalWords
    }
    
    init(){
        
            let allwords=Words.allWords.englishWords
           
        

        
        let fivelw=allwords.filter {word in
            let LowerCase=word.lowercased()
           
            return LowerCase.count == 5 && Set(LowerCase).count==5
        }
        guard let sourceword=fivelw.randomElement() else {
            self.letters=[]
            self.legalWords=[]
            self.requiredLetter=0
            return
        }
        
        let lowercased=sourceword.lowercased()
        
        let unique_char=Set(lowercased)
        
        var lettersArray: [String] = []
        
        for char in unique_char{
            lettersArray.append(String(char))
        }
        
        lettersArray.shuffle()
        
        let requiredIndex=lettersArray.count/2
        
        let legalWordFset=Set(lettersArray)
        
//        let probe = "linee"
////        print("ALLWORDS HAS linee:", allwords.contains(probe))
//        print("ALLWORDS HAS linee lower:", allwords.contains { $0.lowercased() == probe })
//        print("ALLWORDS HAS linee trimmed:", allwords.contains { $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == probe })

            let validwords = allwords.filter{ word in
            let lower = word.lowercased()
            let chars=Set (lower.map {String($0)})
            
            // keep word only if letters are from allowed letters and has the required ceter
            return chars.isSubset(of: legalWordFset) && chars.contains( lettersArray[requiredIndex])
            
            
        }
        
        
        self.letters=lettersArray
        self.requiredLetter=requiredIndex
        self.legalWords=validwords
    }
}
