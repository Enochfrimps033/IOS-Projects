//
//  PokemonRowView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/1/26.
//
import SwiftUI

struct PokemonRowView: View {
    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 14) {
            pokemonImage
            pokemonInfo
            Spacer()
            capturedIndicator
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private var pokemonImage: some View {
        AsyncImage(url: URL(string: "http://127.0.0.1:8000/pokemon/\(pokemon.id)/image")) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 64, height: 64)

            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)

            case .failure:
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
                    .frame(width: 64, height: 64)

            @unknown default:
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
                    .frame(width: 64, height: 64)
            }
        }
        .padding(6)
        .background(Color(.systemBackground).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var pokemonInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(pokemon.name)
                    .font(.headline)

                Spacer()

                Text("#\(String(format: "%03d", pokemon.id))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 6) {
                ForEach(pokemon.types, id: \.self) { type in
                    typeBadge(for: type)
                }
            }

            HStack(spacing: 14) {
                Label("\(pokemon.height, specifier: "%.1f") m", systemImage: "ruler")
                Label("\(pokemon.weight, specifier: "%.1f") kg", systemImage: "scalemass")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }

    private var capturedIndicator: some View {
        Image(systemName: pokemon.captured ? "checkmark.circle.fill" : "circle")
            .font(.title3)
            .foregroundStyle(pokemon.captured ? .red : .gray.opacity(0.5))
    }

    private func typeBadge(for type: PokemonType) -> some View {
        Text(type.rawValue)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(pokemonType: type).opacity(0.18))
            .foregroundStyle(Color(pokemonType: type))
            .clipShape(Capsule())
    }
}

#Preview {
    PokemonRowView(pokemon: .standard)
        .padding()
}
