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
    
    
    let smoothingStrength: CGFloat = 0.5
    let maxJumpDistance: CGFloat = 0.25
    let minConfidence: Float = 0.4
    
    private func processPoints (
        
        _ rawPoints:[VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) -> [VNHumanBodyPoseObservation.JointName: CGPoint]{
            // if i disappear from framm old point could still be lingering
            currentPoints.removeAll()
        
            for (joint, recognizedPoint) in rawPoints{
                guard recognizedPoint.confidence > minConfidence else {continue}
                
                let newPoint = recognizedPoint.location
                //smoothed point less noiser than prevoius
                
                if let previous = smoothedPoints[joint]{
                    let dx = newPoint.x - previous.x
                    let dy = newPoint.y - previous.y
                    // pyth thrm because is will caluate the distance moved 2 pts
                    // it will work for diagonal, verterical, or horizontal change
                    let distance = sqrt(dx * dx + dy * dy)
                    //joint jumps to far in a frame skip reading(aka filter)
                    if distance > maxJumpDistance{
                        //smoothed stable point from las frame
                        currentPoints[joint] = previous
                        continue
                    }
                    
                }
                
                currentPoints[joint] = newPoint
            }
            
            for(joint, currentPoint) in currentPoints{
                // blends old and new points to reduce jittering(no filtering just avrages points)
                if let previousPoint = smoothedPoints[joint]{
                    let smoothedX = previousPoint.x * smoothingStrength + currentPoint.x * (1.0 - smoothingStrength)
                    let smoothedY = previousPoint.y * smoothingStrength + currentPoint.y * (1.0 - smoothingStrength)
                    
                    smoothedPoints[joint] = CGPoint(x: smoothedX, y:smoothedY)
                    
                }else {
                    smoothedPoints[joint] = currentPoint

                }
            
            }
            previousPoints = currentPoints
            let detectedJoints = Set(currentPoints.keys)
            smoothedPoints = smoothedPoints.filter { detectedJoints.contains($0.key) }

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
                print("Pose detected:", results.count)

                guard let firstDetected = results.first else { return }

//                let joints: [VNHumanBodyPoseObservation.JointName] = [
//                    //face
//                    .nose,
//                    .leftEye,
//                    .rightEye,
//                    .leftEar,
//                    .rightEar,
//                    //upperbody
//                        .neck,
//                        .leftShoulder,
//                        .rightShoulder,
//                    .leftElbow,
//                    .rightElbow,
//                    .leftWrist,
//                    .rightWrist,
//                    
//                    //lowerbody
//                    .root,
//                    .leftHip,
//                    .rightHip,
//                    .leftKnee,
//                    .rightKnee,
//                    .leftAnkle,
//                    .rightAnkle,
//                    
//                    
//                  
//                ]

                guard let allPoints = try? firstDetected.recognizedPoints(.all) else { return }

                let smoothed = processPoints(allPoints)

                onPointsDetected?(smoothed)
            }
   
        } catch {
            print("Pose detection failed:", error)
        }
        
        
    }
}
