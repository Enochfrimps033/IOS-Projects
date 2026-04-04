//
//  SignupView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/3/26.
//

import SwiftUI

struct SignupView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image("pokeball")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)

                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.system(size: 28, weight: .bold))

                    Text("Sign up to continue")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    Task {
                        do {
                            let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                            let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

                            let networkManager = NetworkManager()
                            let tokenResponse = try await networkManager.signup(
                                email: cleanedEmail,
                                password: cleanedPassword
                            )

                            authManager.login(
                                token: tokenResponse.accessToken,
                                email: tokenResponse.user.email
                            )
                        } catch {
                            errorMessage = "Sign up failed"
                            print("Error signing up: \(error)")
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                Button("Already have an account? Log In") {
                    dismiss()
                }
                .font(.footnote)

                Spacer()
            }
            .padding(.horizontal, 28)
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SignupView()
        .environment(AuthManager())
        .environment(PokemonViewModel())
}
