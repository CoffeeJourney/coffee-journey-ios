//
//  SignUpViewModel.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation

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

    private let authService: any AuthServicing

    init(authService: any AuthServicing) {
        self.authService = authService
    }

    func signUp() async {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
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

        do {
            try await authService.signUp(
                name: name.trimmingCharacters(in: .whitespaces),
                email: email.trimmingCharacters(in: .whitespaces),
                password: password
            )
            isRegistered = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
