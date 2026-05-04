//
//  Untitled.swift
//  CoachApp
//
//  Created by Haley Parker on 4/30/26.
//

import SwiftUI
import Charts

struct ResultsView: View {
    let exercise: Exercise
    let repCount: Int
    let repTempos: [TimeInterval]
    let repDepths: [CGFloat]
    var isHistoricalView: Bool = false
    
    // computed stats
    private var avgTempo: TimeInterval {
        guard !repTempos.isEmpty else { return 0 }
        return repTempos.reduce(0, +) / Double(repTempos.count)
    }
    
    private var fastestRep: TimeInterval {
        repTempos.min() ?? 0
    }
    
    private var slowestRep: TimeInterval {
        repTempos.max() ?? 0
    }
    
    private var bestDepth: CGFloat {
        repDepths.min() ?? 180
    }
    
    private var avgDepth: CGFloat {
        guard !repDepths.isEmpty else { return 0 }
        return repDepths.reduce(0, +) / CGFloat(repDepths.count)
    }
    
    private var depthVariation: CGFloat {
        guard !repDepths.isEmpty else { return 0 }
        let deepest = repDepths.min() ?? 180
        let shallowest = repDepths.max() ?? 180
        return shallowest - deepest
    }
    
    private var depthInsight: String {
        guard !repDepths.isEmpty else {
            return "Set complete."
        }
        
        let variation = depthVariation
        
        switch variation {
        case ..<5:
            return "Excellent depth consistency. Every rep hit the same range."
        case 5..<10:
            return "Good depth consistency."
        case 10..<20:
            return "Some depth variation across reps. Aim for more consistency."
        default:
            return "Significant depth variation. Focus on hitting the same depth each rep."
        }
    }
    
    private var coachMessage: String {
        let verdictText: String
        
        if let fastest = repTempos.min(),
           let slowest = repTempos.max(),
           fastest > 0 {
            let velocityLoss = ((slowest - fastest) / fastest) * 100
            switch velocityLoss {
            case ..<20:
                verdictText = "You stayed strong. Save it for next set."
            case 20..<40:
                verdictText = "Solid work."
            case 40..<60:
                verdictText = "Strong effort. You worked hard."
            default:
                verdictText = "Maximum effort. Great job pushing through."
            }
        } else {
            verdictText = "Set complete."
        }
        
        return "Nice work! \(repCount) \(exercise.displayName) reps. \(verdictText) \(depthInsight)"
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color.blue.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .padding(.top, 32)
                    
                    Text("\(exercise.displayName) Set Complete")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    // big rep count card
                    VStack(spacing: 8) {
                        Text("\(repCount)")
                            .font(.system(size: 120, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("REPS")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(4)
                    }
                    .padding(40)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    .padding(.horizontal)
                    
                    // stat boxes
                    HStack(spacing: 16) {
                        StatBox(
                            label: "AVG",
                            value: String(format: "%.2fs", avgTempo)
                        )
                        
                        StatBox(
                            label: "FASTEST",
                            value: String(format: "%.2fs", fastestRep)
                        )
                        
                        StatBox(
                            label: "SLOWEST",
                            value: String(format: "%.2fs", slowestRep)
                        )
                    }
                    .padding(.horizontal)
                    
                    // coach's notes card
                    VStack(spacing: 12) {
                        Text("COACH'S NOTES")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(3)
                        
                        Text(depthInsight)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // tempo chart
                    VStack(alignment: .leading, spacing: 8) {
                        Text("TEMPO PER REP")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(3)
                        
                        Chart {
                            ForEach(Array(repTempos.enumerated()), id: \.offset) { index, tempo in
                                LineMark(
                                    x: .value("Rep", index + 1),
                                    y: .value("Tempo (s)", tempo)
                                )
                                .foregroundStyle(.cyan)
                                
                                PointMark(
                                    x: .value("Rep", index + 1),
                                    y: .value("Tempo (s)", tempo)
                                )
                                .foregroundStyle(.cyan)
                            }
                        }
                        .frame(height: 180)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .onAppear {
                if !isHistoricalView {
                    SpeechCoach.shared.speak(coachMessage)
                }
            }
        }
        .background(Color.black)
    }
}

struct StatBox: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .tracking(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

#Preview {
    ResultsView(
        exercise: .squat,
        repCount: 10,
        repTempos: [1.2, 1.3, 1.4, 1.5, 1.8, 2.0, 2.3, 2.5, 2.8, 3.1],
        repDepths: [95, 92, 90, 88, 90, 93, 95, 98, 100, 102]
    )
}
