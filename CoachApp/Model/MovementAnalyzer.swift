//
//  MovementAnalyzer.swift
//  CoachApp
//
//  Created by Haley Parker on 4/16/26.
//

import Foundation
import Vision
import CoreGraphics

final class MovementAnalyzer{
    func angle(
        at vertex: CGPoint,
        from pointA: CGPoint,
        to pointB: CGPoint
    ) -> CGFloat {
        // acrtan(y,x) rather than arctan(y/x)(becuase this will erase the sign which is important!!
        //how far pointA is away from the  vertex inx and y direction
        let radsA = atan2(pointA.y - vertex.y,pointA.x - vertex.x)
        //how far pointB is away from the  vertex inx and y direction
        let radsB = atan2(pointB.y - vertex.y,pointB.x - vertex.x)
        
        //convert rads to degs
        var degrees = (radsA - radsB) * 180 / .pi
        
        
        
        // Normalize negative angles to 0-360 range first
        //adding 360 to a negative angle gives the same place on the unit circle
        //  -20° and 340° point the exact same direction
        if degrees < 0 { degrees += 360 }

        
        //  joints can't bend past their axis of rotation so the real angle
        // is always the smaller one
        //If math gives us 340°, the joint is
        // actually bent 20° (the short way around)
        if degrees > 180 {degrees = 360 - degrees}
        
        return degrees

    }
    
    
    enum Side {
        case left, right
    }

    func elbowAngle(
        side: Side,
        from points: [VNHumanBodyPoseObservation.JointName: CGPoint]
    ) -> CGFloat? {
        let shoulder = side == .left ? VNHumanBodyPoseObservation.JointName.leftShoulder : .rightShoulder
        let elbow = side == .left ? VNHumanBodyPoseObservation.JointName.leftElbow : .rightElbow
        let wrist = side == .left ? VNHumanBodyPoseObservation.JointName.leftWrist : .rightWrist
        
        guard let s = points[shoulder], let e = points[elbow], let w = points[wrist] else {
            return nil
        }
        
        return angle(at: e, from: s, to: w)
    }
    
    
    func kneeAngle(
        side: Side,
        from points: [VNHumanBodyPoseObservation.JointName: CGPoint]
    ) -> CGFloat? {
        let hip = side == .left ? VNHumanBodyPoseObservation.JointName.leftHip : .leftHip
        let knee = side == .left ? VNHumanBodyPoseObservation.JointName.leftKnee : .leftKnee
        let ankle = side == .left ? VNHumanBodyPoseObservation.JointName.leftAnkle : .leftAnkle

        guard let h = points[hip], let k = points[knee], let a = points[ankle] else {
            return nil
        }
        
        return angle(at: k, from: h, to: a)
    }
    
    
    func shoulderAngle(
        side: Side,
        from points: [VNHumanBodyPoseObservation.JointName: CGPoint]
    ) -> CGFloat? {
        let hip = side == .left ? VNHumanBodyPoseObservation.JointName.leftHip : .rightHip
        let shoulder = side == .left ? VNHumanBodyPoseObservation.JointName.leftShoulder : .rightShoulder
        let elbow = side == .left ? VNHumanBodyPoseObservation.JointName.leftElbow : .rightElbow
        
        guard let h = points[hip], let s = points[shoulder], let e = points[elbow] else {
            return nil
        }
        
        return angle(at: s, from: h, to: e)
    }
    
    func hipAngle(
        side: Side,
        from points: [VNHumanBodyPoseObservation.JointName: CGPoint]
    ) -> CGFloat? {
        let shoulder = side == .left ? VNHumanBodyPoseObservation.JointName.leftShoulder : .rightShoulder
        let hip = side == .left ? VNHumanBodyPoseObservation.JointName.leftHip : .rightHip
        let knee = side == .left ? VNHumanBodyPoseObservation.JointName.leftKnee : .rightKnee
        
        guard let s = points[shoulder], let h = points[hip], let k = points[knee] else {
            return nil
        }
        
        return angle(at: h, from: s, to: k)
    }

   
}


    
