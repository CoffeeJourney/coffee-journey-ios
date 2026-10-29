//
//  ReservationsViewModel.swift
//  CoffeeJourney
//
//  Created by Issa on 07/09/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class ReservationsViewModel {
    private(set) var reservations: [Reservation] = []
    private(set) var workshops: [Workshop] = []
    private(set) var isLoading = false
    var errorMessage: String?

    private let reservationService: any ReservationServicing
    private let workshopService: any WorkshopServicing

    init(
        reservationService: any ReservationServicing,
        workshopService: any WorkshopServicing
    ) {
        self.reservationService = reservationService
        self.workshopService = workshopService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let loadedReservations =
                reservationService.fetchReservations()

            async let loadedWorkshops =
                workshopService.fetchWorkshops()

            let (reservations, workshops) = try await (
                loadedReservations,
                loadedWorkshops
            )

            self.reservations = reservations.sorted { first, second in
                let firstDate = workshops.first { $0.id == first.workshopID }?.startTime ?? .distantFuture
                let secondDate = workshops.first { $0.id == second.workshopID }?.startTime ?? .distantFuture

                return firstDate < secondDate
            }
            self.workshops = workshops
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func workshop(for reservation: Reservation) -> Workshop? {
        workshops.first { $0.id == reservation.workshopID }
    }

    func cancel(_ reservation: Reservation) async {
        do {
            try await reservationService.deleteReservation(id: reservation.id)
            reservations.removeAll { $0.id == reservation.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
