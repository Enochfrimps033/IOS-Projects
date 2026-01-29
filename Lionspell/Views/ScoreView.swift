import SwiftUI

struct ScoreView:View{
    
    let score:Int
    
    var body: some View {
        HStack{
            Text("Score").font(.system(size:16, weight:.semibold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Text("\(score)")
                .font(.system(size:12, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal,12)
                .padding(.vertical,6)
                .background(Capsule().fill(Color.white.opacity(0.6)))
        }
        .padding(.horizontal,6)
        .padding(.vertical,6)
        .background(RoundedRectangle(cornerRadius: 9).fill(Color.white.opacity(0.1)))
        

}
}
