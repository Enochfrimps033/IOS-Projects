//
//  Hexlayout.swift
//  Lionspell
//
//  Created by Haley Parker on 2/7/26.
//

import SwiftUI


struct HexLayout {

    static func offsets(numOuter: Int, tileSize: CGFloat, gap: CGFloat, tileSides: Int) -> [CGSize] {
        guard numOuter > 0 else { return [] }

        let R = (tileSize / 2) * 0.98
        let apothem = R * cos(.pi / CGFloat(tileSides))

        let neighbor = 2 * apothem + gap

        if numOuter == 4 {
            let d = neighbor / sqrt(2)
            return [
                CGSize(width: -d, height: -d),
                CGSize(width:  d, height: -d),
                CGSize(width:  d, height:  d),
                CGSize(width: -d, height:  d)
            ]
        }

       
        if numOuter == 5 {
            let startAngle = -CGFloat.pi / 2
            let step = (2 * CGFloat.pi) / 5

            return (0..<5).map { i in
                let a = startAngle + step * CGFloat(i)
                return CGSize(width: cos(a) * neighbor, height: sin(a) * neighbor)
            }
        }


        if numOuter == 6 {
            let dx = 0.866 * neighbor
            let dy = 0.5 * neighbor

            return [
                CGSize(width:  0,  height: -neighbor),
                CGSize(width:  dx, height: -dy),
                CGSize(width:  dx, height:  dy),
                CGSize(width:  0,  height:  neighbor),
                CGSize(width: -dx, height:  dy),
                CGSize(width: -dx, height: -dy)
            ]
        }

        return []
    }
}
