//
//  TypesView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/1/26.
//

import SwiftUI

struct TypesView: View {
    let pokemonList: [Pokemon] = [
        .standard
    ]

    var groupedPokemon: [PokemonType: [Pokemon]] {
        Dictionary(grouping: pokemonList) { pokemon in
            pokemon.types.first ?? .grass
        }
    }

    var sortedTypes: [PokemonType] {
        groupedPokemon.keys.sorted { $0.rawValue < $1.rawValue }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(sortedTypes, id: \.self) { type in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(type.rawValue.capitalized)
                                .font(.title3)
                                .bold()
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(groupedPokemon[type] ?? []) { pokemon in
                                        NavigationLink {
                                            PokemonDetailView(pokemon: pokemon)
                                        } label: {
                                            VStack(spacing: 8) {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(.gray.opacity(0.2))
                                                    .frame(width: 120, height: 100)
                                                    .overlay(
                                                        Image(systemName: "photo")
                                                            .foregroundStyle(.secondary)
                                                    )

                                                Text(pokemon.name)
                                                    .font(.headline)
                                                    .foregroundStyle(.primary)

                                                Text("#\(pokemon.id)")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(width: 140, height: 170)
                                            .padding()
                                            .background(.thinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("By Type")
        }
    }
}

#Preview {
    TypesView()
}
