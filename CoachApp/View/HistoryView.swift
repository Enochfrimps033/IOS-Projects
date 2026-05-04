//
//  HistoryView.swift
//  CoachApp
//
//  Created by Haley Parker on 5/4/26.
//

import SwiftUI

struct HistoryView: View {
    @State private var groupedWorkouts: [(weekday: String, workouts: [WorkoutSummary])] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("This Week")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                ForEach(groupedWorkouts, id: \.weekday) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(day.weekday.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .tracking(2)
                            .padding(.horizontal)
                        
                        if day.workouts.isEmpty {
                            Text("Rest day")
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        } else {
                            ForEach(day.workouts) { workout in
                                NavigationLink(destination: workoutDetailView(for: workout)) {
                                    WorkoutRow(workout: workout)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("History")
        .onAppear {
            groupedWorkouts = WorkoutHistory.shared.currentWeekGrouped()
        }
    }
    
    @ViewBuilder
    private func workoutDetailView(for workout: WorkoutSummary) -> some View {
        if let exercise = Exercise.from(name: workout.exerciseName) {
            ResultsView(
                exercise: exercise,
                repCount: workout.repCount,
                repTempos: workout.repTempos,
                repDepths: workout.repDepths.map { CGFloat($0) },
                isHistoricalView: true
            )
        } else {
            Text("Unknown workout")
        }
    }
}

struct WorkoutRow: View {
    let workout: WorkoutSummary
    
    private var exerciseColor: Color {
        Exercise.from(name: workout.exerciseName)?.color ?? .gray
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(exerciseColor)
                .frame(width: 4)
                .cornerRadius(2)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(workout.exerciseName)
                        .font(.headline)
                    
                    Text(workout.exerciseName.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(exerciseColor.opacity(0.2))
                        .foregroundColor(exerciseColor)
                        .cornerRadius(8)
                }
                
                Text("\(workout.repCount) reps · \(String(format: "%.2fs", workout.avgTempo)) avg")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(workout.date, style: .time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
