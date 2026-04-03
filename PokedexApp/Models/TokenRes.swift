//
//  TokenRes.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/3/26.
//

import Foundation

struct TokenRes: Codable {
    let accessToken: String
    let tokenType: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
