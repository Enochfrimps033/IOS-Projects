import SwiftUI

struct Letterpad: View {
    @Environment(GameManager.self)private var GM
    let letters: [String]
    let highlightcenter: Int
    
    var body: some View {
        VStack{
            Text("Tap letters to spell a word")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.56))
            
            HStack(spacing: 14) {
                HStack(spacing: 10) {
                    ForEach(letters.indices, id:\.self){ i in
                        LetterButton(letter: letters[i],isRequired: i==highlightcenter)
                        {
                            GM.addLetter(letters[i])
                        }
                    }
                }
            }
        }
            .padding(.vertical, 12)
        }
    }
    
struct LetterButton: View {
    let letter: String
    let isRequired: Bool
    let action: () -> Void
    
    var body: some View {
       
            
            Button(action:action){
                
                Text(letter)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(isRequired ? .black : .white)
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(isRequired ? Color.yellow : Color.white.opacity(0.20))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.25), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
            }
        }
    }

