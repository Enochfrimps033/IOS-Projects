//
//  ContentView.swift
//  CoachApp
//
//  Created by Haley Parker on 4/6/26.
//

import SwiftUI

struct CameraView: View {
    let exercise: Exercise
    @State private var cameraVM = CameraViewModel()
    @State private var showResults = false
    
    // countdown state
    @State private var countdown: Int = 3
    @State private var isCountingDown: Bool = true
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: cameraVM.session)
                .ignoresSafeArea()
            PoseOverlayView(points: cameraVM.detectedPoints)
                .ignoresSafeArea()
            
            VStack {
                // Top bar
                HStack {
                    Text(exercise.displayName.uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.5))
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    Button(action: {
                        cameraVM.isPaused.toggle()
                    }) {
                        Text(cameraVM.isPaused ? "Resume" : "Pause")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(cameraVM.isPaused ? .green.opacity(0.8) : .orange.opacity(0.8))
                            .cornerRadius(20)
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.8)
                            .onEnded { _ in
                                cameraVM.stopSession()
                                
                                WorkoutHistory.shared.save(
                                    exercise: exercise,
                                    repCount: cameraVM.activeCounter.repCount,
                                    repTempos: cameraVM.activeCounter.repTempos,
                                    repDepths: cameraVM.activeCounter.repDepths
                                )
                                
                                showResults = true
                            }
                    )
                }
                .padding()
                
                Spacer()
                
                // Rep counter card
                VStack(spacing: 4) {
                    Text("\(angleLabel) angle: \(Int(cameraVM.currentAngle))°")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    
                    Text("\(cameraVM.activeCounter.repCount)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("REPS")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(3)
                    
                    Text(phaseLabel(cameraVM.activeCounter.currentPhase))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.yellow.opacity(0.9))
                        .padding(.top, 8)
                    
                    if cameraVM.isPaused && !isCountingDown {
                        Text("PAUSED")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(.top, 8)
                    }
                }
                .padding(24)
                .background(.black.opacity(0.5))
                .cornerRadius(20)
                .padding(.bottom, 60)
            }
            
            // countdown overlay
            if isCountingDown {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    Text(countdown > 0 ? "\(countdown)" : "GO!")
                        .font(.system(size: 200, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .blue, radius: 20)
                }
            }
        }
        .navigationDestination(isPresented: $showResults) {
            ResultsView(
                exercise: exercise,
                repCount: cameraVM.activeCounter.repCount,
                repTempos: cameraVM.activeCounter.repTempos,
                repDepths: cameraVM.activeCounter.repDepths
            )
        }
        .onAppear {
            cameraVM.selectedExercise = exercise
            cameraVM.activeCounter.reset()
            cameraVM.checkPermission()
            startCountdown()
        }
    }
    
    // countdown
    private func startCountdown() {
        // pause rep counting during countdown
        cameraVM.isPaused = true
        isCountingDown = true
        countdown = 3
        
        SpeechCoach.shared.speak("3")
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdown -= 1
            
            if countdown == 2 {
                SpeechCoach.shared.speak("2")
            } else if countdown == 1 {
                SpeechCoach.shared.speak("1")
            } else if countdown == 0 {
                SpeechCoach.shared.speak("Go!")
            } else if countdown < 0 {
                // countdown finished
                timer.invalidate()
                isCountingDown = false
                cameraVM.isPaused = false  // unpause rep counting
            }
        }
    }
    
    private var angleLabel: String {
        switch exercise {
        case .squat: return "Knee"
        case .deadlift: return "Hip"
        case .bench: return "Elbow"
        }
    }
    
    private func phaseLabel(_ phase: RepPhase) -> String {
        switch phase {
        case .top: return "Ready"
        case .descending: return "Going down..."
        case .bottom: return "At bottom"
        case .ascending: return "Going up..."
        }
    }
}
