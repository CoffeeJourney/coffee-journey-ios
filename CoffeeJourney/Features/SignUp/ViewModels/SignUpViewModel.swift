//
//  SignUpViewModel.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class SignUpViewModel {
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var isLoading = false
    var errorMessage: String?
    var isRegistered = false
    var isAccountCreated = false

    private let authService: any AuthServicing
    private let sessionManager: SessionManager

    init(
        authService: any AuthServicing,
        sessionManager: SessionManager
    ) {
        self.authService = authService
        self.sessionManager = sessionManager
    }

    func signUp() async {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty,
            !trimmedEmail.isEmpty,
            !password.isEmpty,
            !confirmPassword.isEmpty
        else {
            errorMessage = "Tous les champs sont obligatoires."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Les mots de passe ne correspondent pas."
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        // Étape 1 : créer le compte, une seule fois.
        if !isAccountCreated {
            do {
                try await authService.signUp(
                    name: trimmedName,
                    email: trimmedEmail,
                    password: password
                )

                isAccountCreated = true
            } catch {
                errorMessage = error.localizedDescription
                return
            }
        }

        // Étape 2 : se connecter pour récupérer le token.
        do {
            let token = try await authService.login(
                email: trimmedEmail,
                password: password
            )

            // Étape 3 : enregistrer la session.
            try sessionManager.signIn(token: token)

            isRegistered = true
        } catch {
            errorMessage =
                "Ton compte est créé, mais la connexion automatique a échoué. Réessaie : \(error.localizedDescription)"
        }
    }
}
