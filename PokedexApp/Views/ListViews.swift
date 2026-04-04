//
//  ListViews.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

struct ListView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(PokemonViewModel.self) private var viewModel

    @State private var searchText = ""
    @State private var selectedTypes: Set<PokemonType> = []
    @State private var showCapturedOnly = false

    var filteredPokemon: [Pokemon] {
        viewModel.pokemonList.filter { pokemon in
            let matchesSearch =
                searchText.isEmpty ||
                pokemon.name.localizedCaseInsensitiveContains(searchText)

            let matchesCaptured =
                !showCapturedOnly || pokemon.captured

            let matchesTypes =
                selectedTypes.isEmpty ||
                !selectedTypes.isDisjoint(with: Set(pokemon.types))

            return matchesSearch && matchesCaptured && matchesTypes
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Pokémon...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                } else if filteredPokemon.isEmpty {
                    ContentUnavailableView("No Pokémon found", systemImage: "magnifyingglass")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(filteredPokemon) { pokemon in
                                NavigationLink {
                                    PokemonDetailView(pokemon: pokemon)
                                } label: {
                                    PokemonRowView(pokemon: pokemon)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 20)
                    }
                    .refreshable {
                        await viewModel.fetchPokemon(authManager: authManager)
                    }
                }
            }
            .navigationTitle("Pokédex")
            .searchable(text: $searchText, prompt: "Search Pokémon")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Clear all filters") {
                            showCapturedOnly = false
                            selectedTypes.removeAll()
                        }

                        Toggle("Captured", isOn: $showCapturedOnly)

                        Divider()

                        ForEach(PokemonType.allCases) { type in
                            Button {
                                if selectedTypes.contains(type) {
                                    selectedTypes.remove(type)
                                } else {
                                    selectedTypes.insert(type)
                                }
                            } label: {
                                HStack {
                                    Text(type.rawValue)
                                    Spacer()
                                    if selectedTypes.contains(type) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .task {
                if viewModel.pokemonList.isEmpty {
                    await viewModel.fetchPokemon(authManager: authManager)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    ListView()
        .environment(AuthManager())
        .environment(PokemonViewModel())
}
