//
//  TypesView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/1/26.
//
import SwiftUI

struct TypesView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel = PokemonViewModel()

    var groupedPokemon: [PokemonType: [Pokemon]] {
        var groups: [PokemonType: [Pokemon]] = [:]

        for pokemon in viewModel.pokemonList {
            for type in pokemon.types {
                groups[type, default: []].append(pokemon)
            }
        }

        return groups
    }

    var sortedTypes: [PokemonType] {
        groupedPokemon.keys.sorted { $0.rawValue < $1.rawValue }
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Pokémon...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                } else {
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
                                                        .frame(width: 100, height: 80)

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
                }
            }
            .navigationTitle("By Type")
            .task {
                await viewModel.fetchPokemon(authManager: authManager)
            }
        }
    }
}

#Preview {
    TypesView()
        .environment(AuthManager())
}
