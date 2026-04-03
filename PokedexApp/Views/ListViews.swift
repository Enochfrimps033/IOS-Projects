//
//  ListViews.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

struct ListView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel = PokemonViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Pokémon...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                } else {
                    List(viewModel.pokemonList) { pokemon in
                        NavigationLink {
                            PokemonDetailView(pokemon: pokemon)
                        } label: {
                            PokemonRowView(pokemon: pokemon)
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            .task {
                await viewModel.fetchPokemon(authManager: authManager)
            }
        }
    }
}

#Preview {
    ListView()
        .environment(AuthManager())
}
