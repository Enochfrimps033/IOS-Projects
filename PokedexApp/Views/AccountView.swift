//
//  AccountView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI


struct AccountView: View {
    @Environment(AuthManager.self) var authManager

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Email")
                    .font(.headline)

                Text(authManager.userEmail ?? "No email")
                    .foregroundStyle(.secondary)

                Button("Log Out") {
                    authManager.logout()
                }
                .foregroundStyle(.red)

                Spacer()
            }
            .padding()
            .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView()
        .environment(AuthManager())
}
