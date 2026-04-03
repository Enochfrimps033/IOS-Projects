//
//  NetworkManager.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/3/26.
//

import Foundation




class NetworkManager {
    let baseURL = "http://127.0.0.1:8000"

    func login(email: String, password: String) async throws -> TokenRes {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("LOGIN STATUS:", httpResponse.statusCode)
        print("LOGIN BODY:", String(data: data, encoding: .utf8) ?? "No body")

        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(TokenRes.self, from: data)
    }
    func fetchPokemon(token: String?) async throws -> [Pokemon] {
        guard let url = URL(string: "\(baseURL)/pokemon") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("POKEMON STATUS:", httpResponse.statusCode)
        print("POKEMON BODY:", String(data: data, encoding: .utf8) ?? "No body")

        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Pokemon].self, from: data)
    }
}
