//
//  GridShape.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/27/26.
//

import SwiftUI

struct GridShape: Shape {
    let boardSize: Int
    let blockSize: CGFloat

    func path(in rect: CGRect) -> Path {
        let side = CGFloat(boardSize) * blockSize
        var path = Path()

        for i in 0...boardSize {
            let x = CGFloat(i) * blockSize
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: side))

            let y = CGFloat(i) * blockSize
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: side, y: y))
        }

        return path
    }
}
