//
//  AccountView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

struct AccountView: View {
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)

                    HStack {
                        Text(authManager.userEmail ?? "No email")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    authManager.logout()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                        Spacer()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView()
        .environment(AuthManager())
        .environment(PokemonViewModel())
}
