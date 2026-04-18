//
//  PoseOverlayView.swift
//  CoachApp
//
//  Created by Haley Parker on 4/8/26.
//

import SwiftUI
import Vision
import AVFoundation
struct PoseOverlayView: View {
    let points: [VNHumanBodyPoseObservation.JointName: CGPoint]
    
    
    let connections: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
        
        // this is what connects the joints 
        // Face
        (.leftEar,  .leftEye), (.leftEye,  .nose), (.nose,  .rightEye), (.rightEye,  .rightEar),
        // Neck to head
        (.neck,  .nose),
        // Spine
        (.neck,  .root),
        // Left arm
        (.neck,  .leftShoulder), (.leftShoulder,  .leftElbow), (.leftElbow,  .leftWrist),
        // Right arm
        (.neck,  .rightShoulder), (.rightShoulder, .rightElbow), (.rightElbow,  .rightWrist),
        // Hips
        (.root,  .leftHip), (.root,  .rightHip),
        // Left leg
        (.leftHip,  .leftKnee), (.leftKnee,  .leftAnkle),
        // Right leg
        (.rightHip,  .rightKnee), (.rightKnee,  .rightAnkle),
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                
                
                Canvas {context , size in
                    for (jointA,jointB) in connections{
                        guard
                            let pointA = points[jointA],
                            let pointB = points[jointB]
                        else{continue}
                        
                        
                        let screenA = CGPoint(
                            x: screenX(for: pointA, in: geometry),
                            y: screenY(for: pointA, in: geometry)
                        )
                        
                        
                        
                        let screenB = CGPoint(
                            x: screenX(for: pointB, in: geometry),
                            y: screenY(for: pointB, in: geometry)
                        )
                        
                        var path = Path()
                        path.move(to: screenA)
                        path.addLine(to: screenB)
                        
                        context.stroke(
                            path,
                            with: .color(.white.opacity(0.8)),
                            lineWidth: 2
                        )
                        
                    }
                    
                }
                ForEach(Array(points.keys), id: \.self) { joint in
                    if let point = points[joint] {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .position(
                                x: screenX(for: point, in: geometry),
                                y: screenY(for: point, in: geometry)
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }


    private func feedRect(in geometry: GeometryProxy) -> CGRect {
        let screenW = geometry.size.width
        let screenH = geometry.size.height
        
        // Dynamically read actual camera output dimensions
        let formatDimensions = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        )?.activeFormat.formatDescription
        
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDimensions!)
        
        // Camera buffer is rotated 90° so width/height are swapped
        let cameraAspect = CGFloat(dimensions.width) / CGFloat(dimensions.height)
        
        let screenAspect = screenH / screenW

        if screenAspect > cameraAspect {
            let feedHeight = screenW * cameraAspect
            let offsetY = (screenH - feedHeight) / 2
            return CGRect(x: 0, y: offsetY, width: screenW, height: feedHeight)
        } else {
            let feedWidth = screenH / cameraAspect
            let offsetX = (screenW - feedWidth) / 2
            return CGRect(x: offsetX, y: 0, width: feedWidth, height: screenH)
        }
    }

    private func screenX(for point: CGPoint, in geometry: GeometryProxy) -> CGFloat {
        let rect = feedRect(in: geometry)
        return rect.origin.x + (1 - point.y) * rect.width
    }

    private func screenY(for point: CGPoint, in geometry: GeometryProxy) -> CGFloat {
        let rect = feedRect(in: geometry)
        return rect.origin.y + point.x * rect.height
    }
}
