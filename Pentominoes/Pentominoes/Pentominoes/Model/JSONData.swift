//
//  JSONDataStore\.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/24/26.
//

import Foundation

struct PentominoDataStore {
    let puzzles: [PuzzleOutline]
    let pentominoOutlines: [PentominoOutline]
    let solutions: [String: [String: Position]]
    
    init() {
        puzzles = Self.load([PuzzleOutline].self, name: "PuzzleOutlines")
        pentominoOutlines = Self.load([PentominoOutline].self, name: "PentominoOutlines")
        solutions = Self.load([String: [String: Position]].self, name: "Solutions")
    }
    
    private static func load<T: Decodable>(_ type: T.Type, name: String) -> T {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            fatalError("Missing in bundle: \(name).json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                fatalError("Decoding failed for \(name).json: \(error)")
            }
        } catch {
            fatalError("Reading failed for \(name).json: \(error)")
        }
    }
    
}
