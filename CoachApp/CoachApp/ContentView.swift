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
        }
                .onAppear {
                    cameraVM.checkPermission()
                }
        
    }
}
