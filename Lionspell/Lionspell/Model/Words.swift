//
//  AllWords.swift
//  Lion Spell
//
//  Created by Alfares, Nader on 12/20/25.
//
import Foundation


struct Words: Codable {
    let englishWords: [String]
    let italianWords: [String]
    let germanWords: [String]
    let frenchWords: [String]

    
    enum CodingKeys: String, CodingKey {
        case englishWords
        case italianWords
        case germanWords
        case frenchWords

        
    }
    
    init() {
        guard
            let url = Bundle.main.url(forResource: "Words", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(Words.self, from: data)
        else {
            // Safe fallback (no crash)
            // This shouldn't happen
            self.englishWords = []
            self.italianWords = []
            self.germanWords = []

            self.frenchWords = []

            return
        }
        
        self.englishWords = decoded.englishWords
        self.italianWords = decoded.italianWords
        self.germanWords = decoded.germanWords
        self.frenchWords = decoded.frenchWords

    }
    
    
    func words (for langauge:LanguageSetting)->[String]{
        switch langauge{
        case .english: return englishWords
        case .italian: return italianWords
        case .german: return germanWords

        case .french: return frenchWords


        }
    }
    
    //reloads once 
    static let LoadJson = Words()
}





