import SwiftUI

struct Letterpad: View {
    @Environment(GameManager.self)private var GM
    let letters: [String]
    let highlightcenter: Int
    
    private let tileSize: CGFloat = 60
    private let gap: CGFloat = 6
    
//    private var radius: CGFloat{
//        (tileSize + gap) * 0.90
//    }
    private var AllExceptCenter:[Int]{
        letters.indices.filter{$0 != highlightcenter}
    }
    private var offsets: [CGSize] {
        HexLayout.offsets(numOuter: AllExceptCenter.count, tileSize: tileSize,gap:gap,tileSides: tilesides)
    }
    
    
    //    private var offsets:[CGSize]{
    //        HexLayout.outerOffsets(NumOfTilesAroundCenter:AllExceptCenter.count,radius:radius)
    //    }

    private var tilesides: Int{
        switch letters.count{
        case 5: return 4
        case 6: return 5
        default : return 6
        }
    }
    var body: some View {
        VStack{
            Text("Tap letters to spell a word")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.56))
            
            ZStack{
                LetterButton(letter:letters[highlightcenter], isRequired: true,sides:tilesides){
                    GM.addLetter(letters[highlightcenter])
                }
            
                
                ForEach(Array(zip(AllExceptCenter,offsets)), id: \.0){i, off in
                    LetterButton(letter: letters[i], isRequired: false, sides:tilesides){
                        GM.addLetter(letters[i])
                    }
                    .offset(off)
                }
            }
            .frame(width:260,height : 260)
 
        }
        .frame(maxWidth:.infinity,alignment:.center)

        .padding(.vertical, 12)
        }
    }
    
struct LetterButton: View {
    let letter: String
    let isRequired: Bool
    let sides:Int
    let action: () -> Void
    
    var body: some View {
       
            
            Button(action:action){
                
                Text(letter)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(isRequired ? .black : .white)
                    .frame(width: 60, height: 60)
                    .background(
                        PolygonShape(NumOfSides: sides).fill(isRequired ? Color.yellow : Color.white.opacity(0.20))
                    )
                    .overlay(
                        PolygonShape(NumOfSides:sides).stroke(Color.white.opacity(0.25), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
            }
        }
    }

