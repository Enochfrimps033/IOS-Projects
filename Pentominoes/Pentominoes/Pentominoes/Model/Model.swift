//
//  Model.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/24/26.
//

import Foundation

struct Position: Codable, Hashable {
    var x: Int
    var y: Int
    var orientation: Orientation
}

struct Size: Codable, Hashable{
    var width: Int
    var height: Int
}

struct Piece: Identifiable, Hashable{
    let id = UUID()
    var name: String
    var outline: PentominoOutline

    var position: Position
}

struct Point: Codable , Hashable {
    var x: Int
    var y: Int
}
 


struct PentominoOutline: Codable , Hashable {
    var name: String
    var size: Size
    var outline: [Point]
}
  
struct PuzzleOutline: Codable , Hashable {
    var name: String
    var size: Size
    var outlines: [[Point]]
}
enum Orientation: String, Codable, Hashable {
    case up
    case down
    case left
    case right
    case leftMirrored
    case rightMirrored
    case upMirrored
    case downMirrored
}
 
