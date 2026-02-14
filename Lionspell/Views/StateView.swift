//
//  StateView.swift
//  Lionspell
//
//  Created by Haley Parker on 2/13/26.
//

import SwiftUI

struct WordStatsView: View {
    @Environment(GameManager.self) private var GM
    @Environment(\.dismiss) private var dismiss
    @State private var expanded: Set<Int> = []

    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()

            VStack(spacing: 12) {
                
                HStack {
                    Button { dismiss() } label: {
                        HStack(spacing: 8) {
                          
                        }
                        .foregroundStyle(.white.opacity(0.85))
                    }

                    Spacer()

                    Text("Word Stats")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(.yellow)

                    Spacer()
                    Color.clear.frame(width: 60, height: 1)
                }
                .padding(.horizontal)

                List {
                    ForEach(GM.availableLengths, id: \.self) { len in
                        Section {
                            if expanded.contains(len) {
                                ForEach(GM.startingLetterCounts(for: len), id: \.0) { letter, count in
                                    HStack {
                                        Text(letter)
                                        Spacer()
                                        Text("\(count)")
                                    }
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.85))
                                    .listRowBackground(Color.white.opacity(0.05))
                                }
                            }
                        } header: {
                            Button {
                                if expanded.contains(len) { expanded.remove(len) }
                                else { expanded.insert(len) }
                            } label: {
                                HStack {
                                    Text("\(len)-letter words")
                                    Spacer()
                                    Text("\(GM.wordsByLength[len]?.count ?? 0)")
                                    Image(systemName: expanded.contains(len) ? "chevron.down" : "chevron.right")
                                        .foregroundStyle(.white.opacity(0.70))
                                }
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.90))
                            }
                            .textCase(nil)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}
