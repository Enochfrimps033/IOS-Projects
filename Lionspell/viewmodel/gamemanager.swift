//
//  gamemanager.swift
//  Lionspell
//
//  Created by Haley Parker on 1/26/26.
//


//create a class
    // class is wrapped with @observable
// create var for scramble reps single game
    // new game? CREATE NEW SCRAMBLE
    // keep track of points, words,currentword
    // function view is going to use,entering letter,deleteing letter,submitting

import Foundation
import SwiftUI

@Observable

class GameManager{
    //if user chnages preference
    var preferences: Preferences {
        didSet { startNewGame() }
    }
    var _showHints: Bool = false

    
    var scramble:Scramble
    var currentWord:String
    var foundWords: Set<String>
    var Score:Int
    var message: String=""
    
    
    
    init(){
        //does this have to be a default value?
        let initialPreferences = Preferences(language: .english, size: .five)

            self.preferences = initialPreferences
            self.currentWord = ""
            self.foundWords = []
            self.Score = 0
            self.message = ""
            self.scramble = Scramble(preferences: initialPreferences)

    }
    
    
    func startNewGame() {
        scramble = Scramble(preferences: preferences)
            currentWord = ""
            foundWords.removeAll()
            Score = 0
            message = ""

        }
    
    func addLetter(_ letter:String){
        currentWord.append(letter.lowercased())
        // create map/dict

    }
    //remove specified index
    func deleteLetter(){
        guard !currentWord.isEmpty else { return }
        currentWord.removeLast()
        // use pos
        
        
    }
    
    
    func submitWord(){
        let word=currentWord
        //            print("SUBMIT:", word)
        ////            print("LETTERS:", scramble.letters)
        ////            print("REQUIRED INDEX:", scramble.requiredLetter)
        ////            print("REQUIRED LETTER:", scramble.letters[scramble.requiredLetter])
        ////            print("LEGALWORDS COUNT:", scramble.legalWords.count)
        ////            print("IN LEGALWORDS:", scramble.legalWords.contains(word))
        ///
        let RL=scramble.letters[scramble.requiredLetter]
        
        if word.isEmpty{
            message="Type a word first"
            return
        }
        
        if !word.contains(RL){
            message="Missing required letter \(RL.uppercased())"
            return
            
        }
        
        if !scramble.legalWords.contains(word){
            message="Not a valid word"
            return
        }
        
        else{
            
            message="valid word"
            
            
        }
        
            message=""
    
        
        if foundWords.contains(word){
            message="Already found"
            return
            
            
        }
            
        
                  
                  
    
        foundWords.insert(word)
                
                
                let PointsEarned=points(for:word)
                
                Score=Score+PointsEarned
                
                currentWord=""
                
            }
    
    func shuffleLetter(){
        let centerIndex=scramble.letters.count/2
        let required=scramble.letters[scramble.requiredLetter]
        
        var notCenter=scramble.letters.enumerated().filter{ $0.offset != scramble.requiredLetter}.map {$0.element}
        notCenter.shuffle()

        var NewLetters:[String]=[]
        NewLetters.append(contentsOf: notCenter.prefix(centerIndex))
        NewLetters.append(required)
        NewLetters.append(contentsOf: notCenter.dropFirst(centerIndex))
        

        var rearranged=scramble.letters
        rearranged.shuffle()
        
        scramble=Scramble(
            letters:NewLetters,
            requiredLetter: centerIndex,
            legalWords: scramble.legalWords
        )
    }
//    
//    func KeepCenter() {
//        let required=scramble.letters[scramble.requiredLetter]
//        
//        var notCenter=scramble.letters.filter{$0 != required}
//        
//        
//    
//      
//            
//            
//    }
    //give pts for certain word
internal func points(for word:String)->Int{
    var points = 0
    if word.count==4{
        points=1
    }
    else {
        points=word.count
    }
    
    let uniqueLettersPanagram=Set(word)
    if uniqueLettersPanagram.count==scramble.letters.count{
        points+=10
    }
    
    
    return points
    
    
    
    
    
    
}
        
        
        
    
}
