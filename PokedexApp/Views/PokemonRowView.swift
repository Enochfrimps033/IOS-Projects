//
//  PokemonRowView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/1/26.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(pokemon.name)
                    .font(.headline)

                Text("#\(pokemon.id)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("Height: \(pokemon.height)")
                    Text("Weight: \(pokemon.weight)")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PokemonRowView(pokemon: .standard)
}
