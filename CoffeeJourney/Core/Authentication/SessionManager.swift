//
//  SessionManager.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class SessionManager {
    private(set) var token: String?
    private(set) var isAuthenticated = false

    private let keychain: KeychainService

    init(
        keychain: KeychainService = KeychainService(),
        previewToken: String? = nil,
        forceLoggedOut: Bool = false
    ) {
        self.keychain = keychain

        // Pour la preview Login : ignorer le token du Keychain
        if forceLoggedOut {
            token = nil
            isAuthenticated = false
            return
        }

        // Pour la preview connectée
        if let previewToken {
            let cleanedToken = previewToken.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            if !cleanedToken.isEmpty {
                token = cleanedToken
                isAuthenticated = true
                return
            }
        }

        // Fonctionnement normal de l'application
        do {
            let storedToken = try keychain.readToken()
            token = storedToken
            isAuthenticated = storedToken != nil
        } catch {
            token = nil
            isAuthenticated = false
        }
    }

    func signIn(token: String) throws {
        let cleanedToken = token.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedToken.isEmpty else {
            throw APIError.missingToken
        }

        try keychain.save(token: cleanedToken)
        self.token = cleanedToken
        isAuthenticated = true
    }

    func signOut() throws {
        try keychain.deleteToken()
        token = nil
        isAuthenticated = false
    }
}
