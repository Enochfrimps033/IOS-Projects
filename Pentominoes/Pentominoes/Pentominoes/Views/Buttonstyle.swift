//
//  Buttonstyle.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/27/26.
//

import SwiftUI

struct PillButtonStyle: ButtonStyle {
    let colors: [Color]
    let glow: Color             
    let height: CGFloat = 56

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: height)
            .background(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: glow.opacity(configuration.isPressed ? 0.20 : 0.55),
                    radius: configuration.isPressed ? 8 : 18,
                    x: 0, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
