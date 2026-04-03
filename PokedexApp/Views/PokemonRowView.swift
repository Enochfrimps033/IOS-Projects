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
        HStack(spacing: 16) {

            AsyncImage(url: URL(string: "http://127.0.0.1:8000/pokemon/\(pokemon.id)/image")) { phase in
                switch phase {
                case .empty:
                    ProgressView()

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()

                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)

                @unknown default:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(pokemon.name)
                    .font(.headline)

                Text("#\(pokemon.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    PokemonRowView(pokemon: .standard)
}
