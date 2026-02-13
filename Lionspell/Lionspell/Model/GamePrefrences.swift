//
//  GamePrefrences.swift
//  Lionspell
//
//  Created by Haley Parker on 2/9/26.
//
import SwiftUI

enum LanguageSetting: String,CaseIterable, Identifiable {
    case english = "English"
    case german = "German"
    case french = "French"
    case italian = "Italian"
    
    var id: String {rawValue}
    

    
    
}

enum LetterpadSize: String,CaseIterable, Identifiable {
    case five = "5"
    case six = "6"
    case seven = "7"
    
    var id: String {rawValue}

    var letterCount: Int {
        switch self {
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        }
    }
}

struct Preferences{
    var language: LanguageSetting
    var size: LetterpadSize
}
