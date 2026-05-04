//
//  LiftselectionView.swift
//  CoachApp
//
//  Created by Haley Parker on 4/30/26.
//
import SwiftUI

struct LiftSelectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Your Lift")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            // Squat
            VStack(spacing: 4) {
                NavigationLink(destination: CameraView(exercise: .squat)) {
                    Text("Squat")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                LastWorkoutLabel(exercise: .squat)
            }
            
            // Deadlift
            VStack(spacing: 4) {
                NavigationLink(destination: CameraView(exercise: .deadlift)) {
                    Text("Deadlift")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                LastWorkoutLabel(exercise: .deadlift)
            }
            
            NavigationLink(destination: HistoryView()) {
                           Text("View History")
                               .font(.subheadline)
                               .foregroundColor(.blue)
                               .padding(.top, 20)
                       }
        }
        .padding(.horizontal)
    }
}

struct LastWorkoutLabel: View {
    let exercise: Exercise
    @State private var summary: WorkoutSummary?
    
    var body: some View {
        Group {
            if let summary = summary {
                Text("Last: \(summary.repCount) reps · \(timeAgo(summary.date))")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                Text("No workouts yet")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .onAppear {
            summary = WorkoutHistory.shared.loadLast(for: exercise)
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
