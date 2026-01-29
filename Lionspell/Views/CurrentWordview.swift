//
//  CurrentWordview.swift
//  Lionspell
//
//  Created by Haley Parker on 1/28/26.
//

import SwiftUI
struct CurrentWordView: View {
    let word: String

    var body: some View {
        Text(word.isEmpty ? " " : word)
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.18))
            )
    }
}
