//
//  ProfileViewModel.swift
//  CoffeeJourney
//
//  Created by Issa on 07/09/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProfileViewModel {
    private(set) var user: User?
    private(set) var isLoading = false
    var errorMessage: String?

    private let service: any ProfileServicing
    private let sessionManager: SessionManager

    init(
        service: any ProfileServicing,
        sessionManager: SessionManager
    ) {
        self.service = service
        self.sessionManager = sessionManager
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            user = try await service.fetchProfile()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do {
            try sessionManager.signOut()
        } catch {
            errorMessage = "Impossible d'effacer la session sécurisée."
        }
    }
}
