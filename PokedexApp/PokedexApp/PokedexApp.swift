//
//  PokedexApp.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

@main
struct PokedexApp: App {
    @State private var authManager = AuthManager()
    @State private var pokemonViewModel = PokemonViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(pokemonViewModel)
        }
    }
}
