//
//  PokemonViewModel.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/3/26.
//
import Foundation
import Observation

@Observable
class PokemonViewModel {
    var pokemonList: [Pokemon] = []
    var isLoading = false
    var errorMessage: String?

    private let networkManager = NetworkManager()

    func fetchPokemon(authManager: AuthManager) async {
        isLoading = true
        errorMessage = nil

        do {
            pokemonList = try await networkManager.fetchPokemon(token: authManager.token)
        } catch is CancellationError {
            
        } catch let error as URLError where error.code == .cancelled {
            
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func pokemon(withId id: Int) -> Pokemon? {
        pokemonList.first { $0.id == id }
    }
}
