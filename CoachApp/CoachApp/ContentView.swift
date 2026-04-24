//
//  ContentView.swift
//  CoachApp
//
//  Created by Haley Parker on 4/6/26.
//

import SwiftUI

struct ContentView: View {
    @State private var cameraVM = CameraViewModel()
    
    var body: some View {
        ZStack{
            CameraPreviewView(session: cameraVM.session)
                .ignoresSafeArea()
            PoseOverlayView(points: cameraVM.detectedPoints)
                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(cameraVM.squatCounter.repCount)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                    Text("REPS")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(3)
                    Text(phaseLabel(cameraVM.squatCounter.currentPhase))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.yellow.opacity(0.9))
                        .padding(.top, 8)
                }
                .padding(24)
                .background(.black.opacity(0.5))
                .cornerRadius(20)
                .padding(.bottom, 60)
            }
                
    
        }
                .onAppear {
                    cameraVM.checkPermission()
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
