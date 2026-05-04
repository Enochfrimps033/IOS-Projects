//
//  RepCounter.swift
//  CoachApp
//
//  Created by Haley Parker on 4/20/26.
//
import Foundation
import Observation

enum RepPhase {
    case top
    case descending
    case bottom
    case ascending
}

@Observable
final class RepCounter {
    
    var repCount = 0
    var currentPhase: RepPhase = .top
    var repTempos: [TimeInterval] = []
    var repDepths: [CGFloat] = []
    
    private var ascendingStartTime: Date?
    private var lowestAngleThisRep: CGFloat = 180
    
    private let topThreshold: CGFloat
    private let descendingThreshold: CGFloat
    private let bottomThreshold: CGFloat
    private let ascendingThreshold: CGFloat
    
    init(
        topThreshold: CGFloat,
        descendingThreshold: CGFloat,
        bottomThreshold: CGFloat,
        ascendingThreshold: CGFloat
    ) {
        self.topThreshold = topThreshold
        self.descendingThreshold = descendingThreshold
        self.bottomThreshold = bottomThreshold
        self.ascendingThreshold = ascendingThreshold
    }
    
    func update(angle: CGFloat) {
        switch currentPhase {
        case .top:
            if angle < descendingThreshold {
                currentPhase = .descending
                print(" Descending")
            }
            
            
            
        case .descending:
            // Track the lowest angle seen during descent
            if angle < lowestAngleThisRep {
                lowestAngleThisRep = angle
            }
            if angle <= bottomThreshold {
                currentPhase = .bottom
                print(" Bottom reached")
            }
            
        case .bottom:
            // Continue tracking lowest angle while at bottom
            if angle < lowestAngleThisRep {
                lowestAngleThisRep = angle
            }
            if angle > ascendingThreshold {
                currentPhase = .ascending
                ascendingStartTime = Date()
                print(" Ascending")
            }
            
        case .ascending:
            if angle >= topThreshold {
                currentPhase = .top
                repCount += 1
                
                // Save tempo
                if let startTime = ascendingStartTime {
                    let duration = Date().timeIntervalSince(startTime)
                    repTempos.append(duration)
                    print("Rep \(repCount) — \(String(format: "%.2f", duration))s, depth \(Int(lowestAngleThisRep))°")
                }
                
                // Save depth
                repDepths.append(lowestAngleThisRep)
                
                // Reset for next rep
                ascendingStartTime = nil
                lowestAngleThisRep = 180
            }
            
            
        }
        
        
    }
    // reset clears all state for a fresh workout

    func reset() {
        repCount = 0
        currentPhase = .top
        repTempos.removeAll()
        repDepths.removeAll()
        ascendingStartTime = nil
        lowestAngleThisRep = 180
    }
}
