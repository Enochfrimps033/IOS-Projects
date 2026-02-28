//
//  PentominoShape.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/27/26.
//

import SwiftUI

struct PentominoShape: Shape {
    let outline: PentominoOutline
    let position: Position
    let blockSize: CGFloat
    let extraX: CGFloat

    private func normalizedPoints() -> [Point] {
        let pts = outline.outline
        var minX = Int.max
        var minY = Int.max
        for p in pts {
            minX = min(minX, p.x)
            minY = min(minY, p.y)
        }
        return pts.map { Point(x: $0.x - minX, y: $0.y - minY) }
    }

    private func transformedPoints() -> [Point] {
        let pts = normalizedPoints()

        var maxX = Int.min
        var maxY = Int.min
        for p in pts {
            maxX = max(maxX, p.x)
            maxY = max(maxY, p.y)
        }

        func rot90(_ p: Point) -> Point { Point(x: maxY - p.y, y: p.x) }
        func rot180(_ p: Point) -> Point { Point(x: maxX - p.x, y: maxY - p.y) }
        func rot270(_ p: Point) -> Point { Point(x: p.y, y: maxX - p.x) }
        func mirrorX(_ p: Point) -> Point { Point(x: maxX - p.x, y: p.y) }

        switch position.orientation {
        case .up:
            return pts
        case .right:
            return pts.map(rot90)
        case .down:
            return pts.map(rot180)
        case .left:
            return pts.map(rot270)

        case .upMirrored:
            return pts.map(mirrorX)
        case .rightMirrored:
            return pts.map(mirrorX).map(rot90)
        case .downMirrored:
            return pts.map(mirrorX).map(rot180)
        case .leftMirrored:
            return pts.map(mirrorX).map(rot270)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let pts = transformedPoints()
        guard let first = pts.first else { return path }

        let px = position.x
        let py = position.y

        path.move(to: CGPoint(
            x: CGFloat(first.x + px) * blockSize + extraX,
            y: CGFloat(first.y + py) * blockSize
        ))

        for p in pts.dropFirst() {
            path.addLine(to: CGPoint(
                x: CGFloat(p.x + px) * blockSize + extraX,
                y: CGFloat(p.y + py) * blockSize
            ))
        }

        path.closeSubpath()
        return path
    }
}
