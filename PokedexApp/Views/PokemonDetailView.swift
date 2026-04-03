//
//  PokemonDetailView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/1/26.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: "http://127.0.0.1:8000/pokemon/\(pokemon.id)/image")) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.2))
                            .frame(height: 220)
                            .overlay {
                                ProgressView()
                            }

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .background(.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                    case .failure:
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.2))
                            .frame(height: 220)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }

                    @unknown default:
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.2))
                            .frame(height: 220)
                    }
                }

                Text(pokemon.name)
                    .font(.largeTitle)
                    .bold()

                Text("#\(pokemon.id)")
                    .foregroundStyle(.secondary)

                HStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.gray.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Height: \(pokemon.height)")
                    Text("Weight: \(pokemon.weight)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle(pokemon.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemon: .standard)
    }
}
