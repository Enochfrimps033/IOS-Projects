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

    func signup(email: String, password: String) async throws -> TokenRes {
        guard let url = URL(string: "\(baseURL)/auth/signup") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body = SignupRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("SIGNUP STATUS:", httpResponse.statusCode)
        print("SIGNUP BODY:", String(data: data, encoding: .utf8) ?? "No body")

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

    func capturePokemon(id: Int, token: String?) async throws {
        guard let url = URL(string: "\(baseURL)/pokemon/\(id)/capture") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("CAPTURE STATUS:", httpResponse.statusCode)
        print("CAPTURE BODY:", String(data: data, encoding: .utf8) ?? "No body")

        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
    }

    func releasePokemon(id: Int, token: String?) async throws {
        guard let url = URL(string: "\(baseURL)/pokemon/\(id)/release") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("RELEASE STATUS:", httpResponse.statusCode)
        print("RELEASE BODY:", String(data: data, encoding: .utf8) ?? "No body")

        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
