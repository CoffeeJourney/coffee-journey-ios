//
//  AppContainer.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class AppContainer {
    let sessionManager: SessionManager
    let apiClient: APIClient

    let authService: AuthService
    let workshopService: WorkshopService
    let reservationService: ReservationService
    let profileService: ProfileService

    init(sessionManager providedSessionManager: SessionManager? = nil) {
        let sessionManager = providedSessionManager ?? SessionManager()

        guard let baseURL = URL(string: "http://localhost:8081") else {
            fatalError("URL du backend invalide")
        }

        let configuration = APIConfiguration(baseURL: baseURL)

        let apiClient = APIClient(
            configuration: configuration,
            sessionManager: sessionManager
        )

        self.sessionManager = sessionManager
        self.apiClient = apiClient

        self.authService = AuthService(api: apiClient)
        self.workshopService = WorkshopService(api: apiClient)
        self.reservationService = ReservationService(api: apiClient)
        self.profileService = ProfileService(api: apiClient)
    }
}
