//
//  ReservationService.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

@MainActor
protocol ReservationServicing {
    func fetchReservations() async throws -> [Reservation]
    func fetchReservation(id: UUID) async throws -> Reservation
    func createReservation(
        workshopID: UUID,
        userID: UUID,
        status: String
    ) async throws
    func updateReservation(
        id: UUID,
        status: String
    ) async throws
    func deleteReservation(id: UUID) async throws
}

@MainActor
final class ReservationService: ReservationServicing {
    private let api: APIClient

    init(api: APIClient) {
        self.api = api
    }

    func fetchReservations() async throws -> [Reservation] {
        let data = try await api.send(
            path: "/reservation",
            authenticated: true
        )

        return try APIJSON.makeDecoder().decode(
            [Reservation].self,
            from: data
        )
    }

    func fetchReservation(id: UUID) async throws -> Reservation {
        let data = try await api.send(
            path: "/reservation/\(id.uuidString)",
            authenticated: true
        )

        return try APIJSON.makeDecoder().decode(
            Reservation.self,
            from: data
        )
    }

    func createReservation(
        workshopID: UUID,
        userID: UUID,
        status: String = "confirmed"
    ) async throws {
        let body = try APIJSON.makeEncoder().encode(
            CreateReservationRequest(
                userID: userID,
                workshopID: workshopID,
                status: status
            )
        )

        _ = try await api.send(
            path: "/reservation",
            method: "POST",
            body: body,
            authenticated: true
        )
    }

    func updateReservation(
        id: UUID,
        status: String
    ) async throws {
        let body = try APIJSON.makeEncoder().encode(
            UpdateReservationRequest(status: status)
        )

        _ = try await api.send(
            path: "/reservation/\(id.uuidString)",
            method: "PUT",
            body: body,
            authenticated: true
        )
    }

    func deleteReservation(id: UUID) async throws {
        _ = try await api.send(
            path: "/reservation/\(id.uuidString)",
            method: "DELETE",
            authenticated: true
        )
    }
}
