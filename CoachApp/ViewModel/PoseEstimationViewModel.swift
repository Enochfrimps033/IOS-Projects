//
//  PoseEstimationViewModel.swift
//  CoachApp
//
//  Created by Haley Parker on 4/7/26.
//

import Foundation
@preconcurrency import AVFoundation
import Observation
import Vision
import CoreVideo

//@Observable(delagates runs of main method which clashes with @observable)
nonisolated
final class PoseEstimationViewModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let request = VNDetectHumanBodyPoseRequest()
    var onPointsDetected :(( [VNHumanBodyPoseObservation.JointName: CGPoint]) -> Void )?
    
    var previousPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    
    var currentPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    
    var smoothedPoints:  [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    
    
    
    let minConfidence: Float = 0.3
    
    private func processPoints(
        _ rawPoints: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]
    ) -> [VNHumanBodyPoseObservation.JointName: CGPoint] {
        
        // if i disappear from frame old points could still be lingering
        currentPoints.removeAll()
        
        for (joint, recognizedPoint) in rawPoints {
            guard recognizedPoint.confidence > minConfidence else { continue }
            
            let newPoint = recognizedPoint.location
            
            if let previous = smoothedPoints[joint] {
                let dx = newPoint.x - previous.x
                let dy = newPoint.y - previous.y
                // pyth thrm because it calculates the distance moved between 2 pts
                // it works for diagonal, vertical, or horizontal change
                let distance = sqrt(dx * dx + dy * dy)
                
                // Adaptive smoothing — different strength based on how far the joint moved
                let smoothingStrength: CGFloat
                if distance < 0.005 {
                    smoothingStrength = 0.7  // tiny jitter → smooth heavily
                } else if distance < 0.05 {
                    smoothingStrength = 0.3   // normal movement → balanced
                } else {
                    smoothingStrength = 0.1   // big movement → trust new data
                }
                
                let smoothedX = previous.x * smoothingStrength + newPoint.x * (1.0 - smoothingStrength)
                let smoothedY = previous.y * smoothingStrength + newPoint.y * (1.0 - smoothingStrength)
                
                smoothedPoints[joint] = CGPoint(x: smoothedX, y: smoothedY)
            } else {
                smoothedPoints[joint] = newPoint
            }
            
            currentPoints[joint] = newPoint
        }
        //remove smoothed entries for joints not detected in this frame
        let detectedJointNames = Set(currentPoints.keys)
        smoothedPoints = smoothedPoints.filter { detectedJointNames.contains($0.key) }
        
        return smoothedPoints
    }
            
            
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
//        print("Frame received")
        // extratcing image from  camera frame
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        do {
            let handler = VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: .leftMirrored,
                options: [:]
            )

            try handler.perform([request])
            if let results = request.results, !results.isEmpty {

                guard let firstDetected = results.first else { return }

//               

                guard let allPoints = try? firstDetected.recognizedPoints(.all) else { return }

                let smoothed = processPoints(allPoints)

                onPointsDetected?(smoothed)
            }
   
        } catch {
            print("Pose detection failed:", error)
        }
        
        
    }
}
