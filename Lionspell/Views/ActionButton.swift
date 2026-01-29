//
//  Untitled 6.swift
//  Lionspell
//
//  Created by Haley Parker on 1/28/26.
//
import SwiftUI
enum ActionButtonStyle {
    case neutral
    case primary
}

struct ActionButton: View {
    let title: String
    let systemImage: String
    let style: ActionButtonStyle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(style == .primary ? Color.green.opacity(0.55) : Color.white.opacity(0.18))
                )
        }
    }
}
