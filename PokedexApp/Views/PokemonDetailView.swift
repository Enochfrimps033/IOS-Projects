//
//  PokemonDetailView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/1/26.
//

import SwiftUI

struct PokemonDetailView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(PokemonViewModel.self) private var viewModel

    let pokemon: Pokemon

    @State private var isCaptured = false
    @State private var errorMessage: String?

    private let networkManager = NetworkManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                imageSection
                headerSection
                statsSection
                weaknessesSection
                evolutionSection

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(pokemon.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isCaptured = pokemon.captured

            if viewModel.pokemonList.isEmpty {
                Task {
                    await viewModel.fetchPokemon(authManager: authManager)
                }
            }
        }
    }
}

private extension PokemonDetailView {
    var imageSection: some View {
        AsyncImage(url: URL(string: "http://127.0.0.1:8000/pokemon/\(pokemon.id)/image")) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 220)
                    .overlay { ProgressView() }

            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

            case .failure:
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 220)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }

            @unknown default:
                EmptyView()
            }
        }
    }

    var headerSection: some View {
        VStack(spacing: 12) {
            Text(pokemon.name)
                .font(.largeTitle)
                .bold()

            Text("#\(pokemon.id)")
                .foregroundStyle(.secondary)

            Button {
                Task {
                    do {
                        if isCaptured {
                            try await networkManager.releasePokemon(
                                id: pokemon.id,
                                token: authManager.token
                            )
                        } else {
                            try await networkManager.capturePokemon(
                                id: pokemon.id,
                                token: authManager.token
                            )
                        }

                        withAnimation {
                            isCaptured.toggle()
                        }

                        await viewModel.fetchPokemon(authManager: authManager)
                    } catch {
                        errorMessage = "Action failed"
                    }
                }
            } label: {
                Text(isCaptured ? "Release" : "Capture")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(isCaptured ? Color.red : Color.blue)
                    .clipShape(Capsule())
            }

            HStack {
                ForEach(pokemon.types, id: \.self) { type in
                    typeBadge(type)
                }
            }
        }
    }

    var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Stats")
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Text("Height")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(pokemon.height, specifier: "%.2f") m")
                        .bold()
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Weight")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(pokemon.weight, specifier: "%.1f") kg")
                        .bold()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var weaknessesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weaknesses")
                .font(.headline)

            HStack {
                ForEach(pokemon.weaknesses, id: \.self) { type in
                    typeBadge(type)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var evolutionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Evolution")
                .font(.headline)

            if let prev = pokemon.prev_evolution, !prev.isEmpty {
                Text("Previous")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(prev, id: \.self) { evoID in
                            if let evoPokemon = viewModel.pokemon(withId: evoID) {
                                NavigationLink {
                                    PokemonDetailView(pokemon: evoPokemon)
                                } label: {
                                    evolutionCard(for: evoPokemon)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Text("Missing #\(evoID)")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }

            if let next = pokemon.next_evolution, !next.isEmpty {
                Text("Next")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(next, id: \.self) { evoID in
                            if let evoPokemon = viewModel.pokemon(withId: evoID) {
                                NavigationLink {
                                    PokemonDetailView(pokemon: evoPokemon)
                                } label: {
                                    evolutionCard(for: evoPokemon)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Text("Missing #\(evoID)")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }

            if (pokemon.next_evolution?.isEmpty ?? true) && (pokemon.prev_evolution?.isEmpty ?? true) {
                Text("No evolution data available")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func typeBadge(_ type: PokemonType) -> some View {
        Text(type.rawValue)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(pokemonType: type).opacity(0.18))
            .foregroundStyle(Color(pokemonType: type))
            .clipShape(Capsule())
    }
    func evolutionCard(for pokemon: Pokemon) -> some View {
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
            .frame(width: 80, height: 60)

            Text(pokemon.name)
                .font(.caption)
                .foregroundStyle(.primary)

            Text("#\(pokemon.id)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(width: 110, height: 130)
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemon: .standard)
            .environment(AuthManager())
            .environment(PokemonViewModel())
    }
}
