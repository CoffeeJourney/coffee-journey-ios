//
//  WorkshopDetailViewModel.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class WorkshopDetailViewModel {
    private(set) var workshop: Workshop?
    private(set) var isLoading = false
    private(set) var isBooking = false
    private(set) var hasAlreadyReserved = false
    private var reservationID: UUID?
    
    var errorMessage: String?
    var successMessage: String?

    private let workshopService: any WorkshopServicing
    private let reservationService: any ReservationServicing
    private let sessionManager: SessionManager
    private let profileService: any ProfileServicing

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

    var canReserve: Bool {
        guard let workshop else { return false }

        return workshop.hasAvailablePlaces
            && !hasAlreadyReserved
            && !isLoading
            && !isBooking
            && sessionManager.isAuthenticated
    }

    func load(workshopID: UUID) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            workshop = try await workshopService.fetchWorkshop(
                id: workshopID
            )

            guard sessionManager.isAuthenticated else {
                hasAlreadyReserved = false
                return
            }

            let reservations = try await reservationService
                .fetchReservations()

            reservationID = reservations.first {
                $0.workshopID == workshopID
            }?.id

            hasAlreadyReserved = reservationID != nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func reserve() async {
        guard canReserve, let workshop else { return }

        isBooking = true
        errorMessage = nil
        successMessage = nil

        defer { isBooking = false }

        do {
            let user = try await profileService.fetchProfile()

            try await reservationService.createReservation(
                workshopID: workshop.id,
                userID: user.id,
                status: "confirmed"
            )

            successMessage = "Reservation confirmed successfully."

            // Recharge les données depuis le serveur.
            await load(workshopID: workshop.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func cancelReservation() async {
        guard let reservationID, let workshop else { return }

        isBooking = true
        errorMessage = nil

        defer { isBooking = false }

        do {
            try await reservationService.deleteReservation(id: reservationID)

            self.reservationID = nil
            hasAlreadyReserved = false

            await load(workshopID: workshop.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
