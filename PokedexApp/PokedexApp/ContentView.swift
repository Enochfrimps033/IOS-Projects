//
//  ContentView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        Group {
            if authManager.isLoggedIn {
                BottomTabView()
            } else {
                LoginView()
            }
        }
        .background(Color(.systemGroupedBackground)) 
    }
}

#Preview {
    ContentView()
        .environment(AuthManager())
        .environment(PokemonViewModel())
}
