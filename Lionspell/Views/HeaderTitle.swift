import SwiftUI

struct HeaderTitle:View{
    var body: some View {
        Text("Lion Spell")
            .font(.system(size:25,weight :.bold,design:.rounded))
            .foregroundStyle(LinearGradient(colors: [.white,Color(white:0.80)],
                                            startPoint: .topLeading, endPoint: .bottomLeading ))
        
            .shadow(color: .black.opacity(0.2),radius:5,x:0,y:2)
                        
      
        
    }
}
