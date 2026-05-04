//
//  Untitled.swift
//  CoachApp
//
//  Created by Haley Parker on 5/3/26.


import Foundation
import AVFoundation

final class SpeechCoach {
    
    static let shared = SpeechCoach()
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() {}
    
    func speak(_ text: String) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        let utterance = AVSpeechUtterance(string: text)
        
        let voices = AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.hasPrefix("en") }
            .sorted { $0.quality.rawValue > $1.quality.rawValue }
        
        utterance.voice = voices.first ?? AVSpeechSynthesisVoice(language: "en-US")
        
        utterance.rate = 0.48
        utterance.pitchMultiplier = 0.95
        utterance.volume = 1.0
        utterance.preUtteranceDelay = 0.3
        
        synthesizer.speak(utterance)
    }
}
