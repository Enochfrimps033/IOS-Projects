//
//  shapes.swift
//  Lionspell
//
//  Created by Haley Parker on 2/6/26.
//
import SwiftUI

struct PolygonShape:Shape{
    
    var NumOfSides :Int
    
    func path(in rect: CGRect)-> Path{
        var path=Path()
        guard NumOfSides >= 3 else{return path}
        
        let Boundarycenter = CGPoint(x: rect.midX, y: rect.midY)
        let Boundaryradius=min(rect.width, rect.height) / 2.0 * 0.98
        
        let TimestoRotate = 2 * CGFloat.pi / CGFloat(NumOfSides)

        let rotation:CGFloat=(NumOfSides==4)
        ?(-CGFloat.pi / 2)
        :(-CGFloat.pi / 2 + TimestoRotate / 2)
        
        for i in 0..<NumOfSides{
            let angle=TimestoRotate * CGFloat(i) + rotation
            let point = CGPoint(
                x:Boundarycenter.x + cos(angle) * Boundaryradius,
                y:Boundarycenter.y + sin(angle) * Boundaryradius
                
                
                
            )
            
            if i==0{
                path.move(to:point)
            }else{
                    path.addLine(to:point)
                }
            
            }
        path.closeSubpath()
        return path
        }
    }


