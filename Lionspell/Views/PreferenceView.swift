//
//  Untitled.swift
//  Lionspell
//
//  Created by Haley Parker on 2/9/26.
//
import SwiftUI
struct PreferenceView: View {
    
    @Environment(GameManager.self) private var GM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            ZStack{
                BackgroundView().ignoresSafeArea()
                
                VStack(spacing:16){
                    
                    HStack{
                        Button{
                            dismiss()
                        } label: {HStack(spacing:16 ){
                            
                        }
                            
                        .foregroundStyle(.white.opacity(0.85))
                            
                        }
                        
                        Spacer()
                        Text("Game Settings")
                            .font(.system(size: 14,weight: .bold, design: .rounded))
                            .foregroundStyle(.yellow)
                        
                        Spacer()
                        
                        Color.clear.frame(width:60,height:1)
                    }
                    .padding(.horizontal)//.padding(.top,10) can i do this here
                    
                    
                    SettingsCard(title: "Language",SystemImage:"globe"){
                        PillSegmentedControl(
                            options:LanguageSetting.allCases,
                            selection:Binding(
                                get:{GM.preferences.language},
                                set:{GM.preferences.language=$0}
                            ),
                            label:{$0.rawValue}
                        )
                    }
                    
                    SettingsCard(title:"Difficulty Level", SystemImage: "textformat.abc"){
                        PillSegmentedControl(
                            options:LetterpadSize.allCases,
                            selection:Binding(
                                get:{GM.preferences.size},
                                set:{GM.preferences.size=$0}
                            ),
                            label:{"\($0.letterCount) Letters"}
                            
                        )
                        Text("Choose difficulty level")
                            .font(.system(size:12,weight:.semibold,design:.rounded))
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(.top,8)
                        
                    }
                    
                    SettingsCard(title: "Hints",SystemImage:"lightbulb") {
                        
                        Toggle(
                            
                            isOn: Binding(
                                
                                get:{GM.showHints},
                                set:{GM.showHints = $0}
                            )){
                                
                                VStack(alignment: .leading, spacing: 4){
                                    Text("Show Hints")
                                        .font(.system(size:14,weight:.bold,design: .rounded))
                                    
                                    
                                    Text("View available words and statistics")
                                        .font(.system(size:12,weight: .semibold,design: .rounded))
                                        .foregroundStyle(.white.opacity(0.85))
                                    
                                    
                                }
                                
                            }
                            .toggleStyle(SwitchToggleStyle(tint:.yellow))
                    }
                    if GM.showHints{
                        
                        SettingsCard(title: "Points",SystemImage:"star.fill") {
                            HStack{
                                Text("Points")
                                Spacer()
                                Text("\(GM.totalPossiblePoints)")
                            }
                            
                        }
                        
                        SettingsCard(title: "Words",SystemImage:"textformat") {
                            NavigationLink{
                                AllPossibleWordsView()
                            }label: {
                                HStack{
                                    Text("All legal words")
                                    
                                    Spacer()
                                    Text("\(GM.legalwordCount)")
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.80))
                                }
                                .foregroundStyle(.white.opacity(0.85))
                            }
                        }
                        SettingsCard(title: "Pangrams",SystemImage:"circle.grid.2x2.fill") {
                            NavigationLink{
                                PangramView()
                            }label: {
                                HStack{
                                    Text("Pangrams")
                                    Spacer()
                                    Text("\(GM.pangram)")
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.80))
                                }
                            }
                        }
                        SettingsCard(title: "Stats", SystemImage: "chart.bar") {
                            NavigationLink {
                                WordStatsView()
                            } label: {
                                HStack {
                                    Text("Words by length & letter")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.80))
                                }
                                .foregroundStyle(.white.opacity(0.85))
                            }
                        }

                        
                    }
                    
                    
                }
                Spacer()
            }
            .padding(.top,10)
            
            
        }
    }
    
    
    private struct SettingsCard<Content: View>: View{
        let title:String
        let SystemImage: String
        @ViewBuilder let content:Content
        
        var body: some View{
            VStack(alignment: .leading ,spacing :12){
                HStack(spacing:10){
                    Image(systemName: SystemImage)
                        .foregroundStyle(.white.opacity( 0.85))
                    
                    Text(title)
                        .font(.system(size:14,weight :.bold,design:.rounded ))
                    
                    Spacer()
                }
                content
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12)))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.15), lineWidth:1)
            )
            .padding(.horizontal)
        }
    }
    
    private struct PillSegmentedControl<Option: Hashable>:View{
        let options: [Option]
        @Binding var selection : Option
        let label: (Option) -> String
        
        var body: some View {
            HStack(spacing: 8){
                ForEach(options, id:\.self){opt in
                    let isSelected=(opt == selection)
                    
                    Button{
                        selection=opt
                    }label:{
                        Text(label(opt))
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(isSelected ? .black : .white.opacity(0.75))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(isSelected ? Color.yellow : Color.white.opacity(0.10))
                            )
                        
                    }
                    .buttonStyle(.plain)
                }
            }
            
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.18))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
        }
    }
    
}
