//
//  LoginViewModel.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?

    private let authService: any AuthServicing
    private let sessionManager: SessionManager

    init(
        authService: any AuthServicing,
        sessionManager: SessionManager
    ) {
        self.authService = authService
        self.sessionManager = sessionManager
    }

    func login() async {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = "Renseigne ton email et ton mot de passe."
            return
        }

        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let token = try await authService.login(
                email: email.trimmingCharacters(in: .whitespaces),
                password: password
            )

            try sessionManager.signIn(token: token)
            
            print(token)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
