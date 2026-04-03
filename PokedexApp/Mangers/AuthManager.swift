//
//  AuthManager.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import Foundation
import Observation

@Observable
class AuthManager {
    var token: String? {
        didSet {
            if let token {
                UserDefaults.standard.set(token, forKey: "auth_token")
            } else {
                UserDefaults.standard.removeObject(forKey: "auth_token")
            }
        }
    }

    var userEmail: String? {
        didSet {
            if let userEmail {
                UserDefaults.standard.set(userEmail, forKey: "user_email")
            } else {
                UserDefaults.standard.removeObject(forKey: "user_email")
            }
        }
    }

    var isLoggedIn: Bool {
        token != nil
    }

    init() {
        restoreSession()
    }

    func login(token: String, email: String) {
        self.token = token
        self.userEmail = email
    }

    func logout() {
        token = nil
        userEmail = nil
    }

    func restoreSession() {
        token = UserDefaults.standard.string(forKey: "auth_token")
        userEmail = UserDefaults.standard.string(forKey: "user_email")
    }
}
