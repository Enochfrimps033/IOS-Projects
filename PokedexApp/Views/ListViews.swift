//
//  ListViews.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

struct ListView: View {
    let pokemonList: [Pokemon] = [
        .standard
    ]

    var body: some View {
        NavigationStack {
            List(pokemonList) { pokemon in
                NavigationLink {
                    PokemonDetailView(pokemon: pokemon)
                } label: {
                    PokemonRowView(pokemon: pokemon)
                }
            }
            .navigationTitle("Pokédex")
        }
    }
}

#Preview {
    ListView()
}
