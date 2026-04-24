//
//  RepCounter.swift
//  CoachApp
//
//  Created by Haley Parker on 4/20/26.
//

import Foundation
import Observation
enum RepPhase {
    case top         // standing upright
    case descending  // going down
    case bottom      // at squat depth
    case ascending   // standing back up
}

@Observable
final class RepCounter {
    
    // Public — what the UI reads
    var repCount = 0
    var currentPhase: RepPhase = .top
    
    // Thresholds for squat (we'll use these for now)
    private let topThreshold: CGFloat      // standing up
    private let descendingThreshold: CGFloat // starting to bend
    private let bottomThreshold: CGFloat    // squat depth
    private let ascendingThreshold: CGFloat  // leaving bottom
    
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
    
    // The main function — call this every frame with the current knee angle
    func update(angle: CGFloat) {
        switch currentPhase {
            
        case .top:
            if angle < descendingThreshold {
                currentPhase = .descending
                print(" Descending")
            }
            
        case .descending:
            if angle <= bottomThreshold {
                currentPhase = .bottom
                print(" Bottom reached")
            }
            
        case .bottom:
            if angle > ascendingThreshold {
                currentPhase = .ascending
                print(" Ascending")
            }
            
        case .ascending:
            if angle >= topThreshold {
                currentPhase = .top
                repCount += 1
                print("Rep complete! Total: \(repCount)")
            }
        }
    }
}
