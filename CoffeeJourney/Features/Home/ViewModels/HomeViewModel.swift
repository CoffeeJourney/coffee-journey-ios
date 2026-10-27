//
//  HomeViewModel.swift
//  CoffeeJourney
//
//  Created by Issa on 07/09/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var nextWorkshops: [Workshop] = []
    private(set) var userName: String?
    private(set) var isLoading = false
    var errorMessage: String?

    private let workshopService: any WorkshopServicing
    private let reservationService: any ReservationServicing
    private let profileService: any ProfileServicing
    private let sessionManager: SessionManager

    init(
        workshopService: any WorkshopServicing,
        reservationService: any ReservationServicing,
        profileService: any ProfileServicing,
        sessionManager: SessionManager
    ) {
        self.workshopService = workshopService
        self.reservationService = reservationService
        self.profileService = profileService
        self.sessionManager = sessionManager
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let workshops = try await workshopService.fetchWorkshops()

            guard sessionManager.isAuthenticated else {
                userName = nil
                nextWorkshops = []
                return
            }

            async let reservationsTask =
                reservationService.fetchReservations()

            async let profileTask =
                profileService.fetchProfile()

            let (reservations, profile) = try await (
                reservationsTask,
                profileTask
            )

            userName = profile.name

            let reservedWorkshopIDs = Set(
                reservations.map(\.workshopID)
            )

            nextWorkshops = workshops
                .filter {
                    reservedWorkshopIDs.contains($0.id)
                    && $0.startTime > Date()
                }
                .sorted {
                    $0.startTime < $1.startTime
                }
                .prefix(2)
                .map { $0 }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
