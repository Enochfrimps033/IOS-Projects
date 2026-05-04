//
//  WorkoutHistory.swift
//  CoachApp
//
//  Created by Haley Parker on 5/3/26.
//
import Foundation

// stores a single completed workout
struct WorkoutSummary: Codable, Identifiable {
    var id = UUID()
    let exerciseName: String
    let repCount: Int
    let avgTempo: Double
    let bestDepth: Double
    let date: Date
    let repTempos: [TimeInterval]
    let repDepths: [Double]
}

final class WorkoutHistory {
    
    static let shared = WorkoutHistory()
    private let defaults = UserDefaults.standard
    private let storageKey = "allWorkouts"
    
    private init() {}
    
    // save a new workout
    func save(exercise: Exercise, repCount: Int, repTempos: [TimeInterval], repDepths: [CGFloat]) {
        guard !repTempos.isEmpty else { return }
        
        let avgTempo = repTempos.reduce(0, +) / Double(repTempos.count)
        let bestDepth = Double(repDepths.min() ?? 180)
        
        let newWorkout = WorkoutSummary(
            exerciseName: exercise.displayName,
            repCount: repCount,
            avgTempo: avgTempo,
            bestDepth: bestDepth,
            date: Date(),
            repTempos: repTempos,
            repDepths: repDepths.map { Double($0) }
        )
        
        var workouts = loadAll()
        workouts.append(newWorkout)
        
        if let encoded = try? JSONEncoder().encode(workouts) {
            defaults.set(encoded, forKey: storageKey)
            print("Saved workout. Total: \(workouts.count)")
        }
    }
    
    // load all stored workouts
    func loadAll() -> [WorkoutSummary] {
        guard let data = defaults.data(forKey: storageKey),
              let workouts = try? JSONDecoder().decode([WorkoutSummary].self, from: data)
        else {
            return []
        }
        return workouts
    }
    
    // load last workout for a specific exercise
    func loadLast(for exercise: Exercise) -> WorkoutSummary? {
        loadAll()
            .filter { $0.exerciseName == exercise.displayName }
            .sorted { $0.date > $1.date }
            .first
    }
    
    // get this week's workouts grouped by weekday
    func currentWeekGrouped() -> [(weekday: String, workouts: [WorkoutSummary])] {
        let calendar = Calendar.current
        let now = Date()
        
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        components.weekday = 2
        guard let weekStart = calendar.date(from: components) else { return [] }
        
        let allWorkouts = loadAll()
        let thisWeekWorkouts = allWorkouts.filter { $0.date >= weekStart }
        
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        return weekdays.enumerated().map { (index, name) in
            let dayWorkouts = thisWeekWorkouts.filter { workout in
                let workoutWeekday = calendar.component(.weekday, from: workout.date)
                let adjusted = workoutWeekday == 1 ? 7 : workoutWeekday - 1
                return adjusted == index + 1
            }
            return (weekday: name, workouts: dayWorkouts)
        }
    }
    
    // clear all history
    func clearAll() {
        defaults.removeObject(forKey: storageKey)
    }
}
