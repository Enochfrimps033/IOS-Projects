 //
//  GameManager+Hints.swift
//  Lionspell
//
//  Created by Haley Parker on 2/13/26.
//
extension GameManager {
    var showHints: Bool{
        get{_showHints }
        set{_showHints = newValue}
    }
    
    
    var legalwordCount: Int{
        scramble.legalWords.count
    }
    
    var pangram: Int{
        let n=(scramble.letters.count)
        var PangramCount=0
        
        for i in scramble.legalWords{
            if Set(i).count == n{
                PangramCount+=1
                
            }
        }
        return PangramCount
    }
    
    
    var totalPossiblePoints: Int{
        
        var totalPangram=0
        
        for pan in scramble.legalWords{
            totalPangram += points(for: pan)
            
        }
        return totalPangram
    }
    
    
    var pangramWords: [String]{
        let n=scramble.letters.count
        return scramble.legalWords.filter { Set($0).count == n }.sorted()
        
    }
    
    
    var WordsByLength: [Int: Int] {
            Dictionary(grouping: scramble.legalWords, by: { $0.count })
                .mapValues { $0.count }
        }

    var wordsByLength: [Int: [String]] {
            Dictionary(grouping: scramble.legalWords, by: { $0.count })
        }

        var availableLengths: [Int] {
            wordsByLength.keys.sorted()
        }
    
    func startingLetterCounts(for length: Int) -> [(String, Int)] {
        let words = wordsByLength[length] ?? []

        let counts = Dictionary(grouping: words, by: { String($0.prefix(1)).uppercased() })
            .mapValues { $0.count }

        return counts.sorted { $0.0 < $1.0 }
    }

    
    
    
    
}
