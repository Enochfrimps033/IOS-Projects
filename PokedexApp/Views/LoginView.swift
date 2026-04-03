//
//  LoginView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) var authManager

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Pokédex Login")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Log In") {
                    Task{
                        
                        do{
                            let networkManager = NetworkManager()
                            let tokenResponse = try await networkManager.login(email: email, password: password)
                            authManager.login(token: tokenResponse.accessToken, email: email)
                        } catch {
                            print("Error logging in: \(error)")
                        }
                    }
                    
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
