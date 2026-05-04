//
//  CameraViewModel.swift
//  CoachApp
//
//  Created by Haley Parker on 4/6/26.
//

import Foundation
import AVFoundation
import Observation
import SwiftUI
import Vision

enum Exercise{
    case squat
    case deadlift
    case bench
    
    var displayName: String{
        switch self {
        case .squat: return "Squat"
        case .deadlift: return "Deadlift"
        case .bench: return "Bench"
        }
    }
    
    var color: Color {
        switch self {
        case .squat: return .blue
        case .deadlift: return .green
        case .bench: return .orange
        }
    }
    
    // convertsa saved exercise name back to Exercise
    static func from(name: String) -> Exercise? {
        switch name {
        case "Squat": return .squat
        case "Deadlift": return .deadlift
        case "Bench": return .bench
        default: return nil
        }
    }
}
@Observable
final class CameraViewModel {
    
    var currentAngle: CGFloat = 0
    let session = AVCaptureSession()
    //creates background view for camera
    let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    let poseEstimator = PoseEstimationViewModel()
    
    var detectedPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    
    var isPaused: Bool = false
    
    let analyzer = MovementAnalyzer()
    
   
    
    var selectedExercise : Exercise = .squat
    
    let squatCounter = RepCounter(
        topThreshold: 160,
        descendingThreshold: 140,
        bottomThreshold: 100,
        ascendingThreshold: 110
        
    )
    
    let deadliftCounter = RepCounter(
        topThreshold: 160,
        descendingThreshold: 140,
        bottomThreshold: 100,
        ascendingThreshold: 110
        
    )
    
    let benchCounter = RepCounter(
        topThreshold: 160,
        descendingThreshold: 140,
        bottomThreshold: 90,
        ascendingThreshold: 100
    )
    
    // returns the counter for the currently selected exercise
    var activeCounter: RepCounter {
        switch selectedExercise {
        case .squat: return squatCounter
        case .deadlift: return deadliftCounter
        case .bench: return benchCounter
        }
    }
    
    func checkPermission(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case.authorized:
            
            setupCamera()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ granted in
                if granted {
                    self.setupCamera()
                }
                else{
                    self.stopSession()
                }
                
            }
        case.denied, .restricted:
            print("Camera access denied")
            
        @unknown default:
            break
            
        }
        
    }
    
    func setupCamera() {
        guard let cameraDevice =
            AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else {
            print("No camera")
            return
        }

        sessionQueue.async {
            self.poseEstimator.onPointsDetected = { points in
                DispatchQueue.main.async {
                    self.detectedPoints = points
                    // Elbows
                    if let angle = self.analyzer.elbowAngle(side: .left, from: points) {
            //                        print(" L elbow: \(Int(angle))°")
                    }
                    if let angle = self.analyzer.elbowAngle(side: .right, from: points) {
            //                        print(" R elbow: \(Int(angle))°")
                    }
                    
                    // Knees
                    if let angle = self.analyzer.kneeAngle(side: .left, from: points) {
            //                        print(" L knee: \(Int(angle))°")
                    }
                    if let angle = self.analyzer.kneeAngle(side: .right, from: points) {
            //                        print(" R knee: \(Int(angle))°")
                    }
                    
                    // Shoulders
                    if let angle = self.analyzer.shoulderAngle(side: .left, from: points) {
            //                        print(" L shoulder: \(Int(angle))°")
                    }
                    
                    // Hips
                    if let angle = self.analyzer.hipAngle(side: .left, from: points) {
            //
                    }
                    
                    // skip rep counting if paused
                    if self.isPaused { return }
                    
                    // update the active counter based on selected exercise
                    switch self.selectedExercise {
                    case .squat:
                        //squat counter
                        if let avgKnee = self.analyzer.kneeAngleAvg(from: points){
                            self.currentAngle = avgKnee
                            self.squatCounter.update(angle: avgKnee)
                        }
                    case .deadlift:
                        //deadlift counter
                        if let avgHip = self.analyzer.hipAngleAvg(from: points){
                            self.currentAngle = avgHip
                            self.deadliftCounter.update(angle: avgHip)
                        }
                    case .bench:
                        //bench counter
                        if let avgElbow = self.analyzer.elbowAngleAvg(from: points){
                            self.currentAngle = avgElbow
                            self.benchCounter.update(angle: avgElbow)
                        }
                    }
                }
            }
            
            self.session.beginConfiguration()

            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(
                self.poseEstimator,
                queue: DispatchQueue(label: "video.queue")
            )

            do {
                let input = try AVCaptureDeviceInput(device: cameraDevice)

                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }

                if self.session.canAddOutput(output) {
                    self.session.addOutput(output)
                    
                    if let  connection = output.connection(with : .video){
                        if connection.isVideoRotationAngleSupported(90){
                            connection.videoRotationAngle = 90
                        }
                        if connection.isVideoMirroringSupported{
                            connection.isVideoMirrored = true
                        }
                    }
                }

                self.session.commitConfiguration()
                self.session.startRunning()

                print("Session running:", self.session.isRunning)

            } catch {
                print("Failed to create camera input")
            }
        }
    }
    // should not run on main thread( i was getting black screen) so create a session queue
    func startSession(){
        sessionQueue.async {
            if !self.session.isRunning{
                self.session.startRunning()
            }
        }
        
        
    }
    
    func stopSession(){
        sessionQueue.async{
            if self.session.isRunning{
                self.session.stopRunning()
            }
            
            
        }
    }
}
