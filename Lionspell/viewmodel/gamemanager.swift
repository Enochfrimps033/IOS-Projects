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
    var scramble: Scramble
    
    var currentWord:String
    
    var foundWords: Set<String>
    
    var Score:Int
    
    
    
    
    
    init(){
        self.scramble=Scramble()
        self.currentWord=""
        self.foundWords=[]
        self.Score=0
        
    }
    
    
    func startNewGame(){
        scramble=Scramble()
        currentWord=""
        foundWords.removeAll()
        Score=0
    }
    
    
    
    
    func addLetter(_ letter:String){
        currentWord.append(letter.lowercased())
    }
    //remove specified index
    func deleteLetter(){
        guard !currentWord.isEmpty else { return }
        currentWord.removeLast()
        
        
        
    }
    
    func submitWord(){
        let word=currentWord.lowercased()
        
        if scramble.legalWords.contains(word){
            if !foundWords.contains(word){
                foundWords.insert(word)
                
                
                let PointsEarned=points(for:word)
                
                Score=Score+PointsEarned
                
                currentWord=""
                
            }
        }
    }
    
    //give pts for certain word
    private func points(for word:String)->Int{
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
