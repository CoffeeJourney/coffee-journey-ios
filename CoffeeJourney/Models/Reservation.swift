//
//  Reservation.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

struct Reservation: Codable, Identifiable, Sendable {
    let id: UUID
    let userID: UUID
    let workshopID: UUID
    let status: String
}

struct ReservationWithWorkshop: Codable, Sendable {
    let name: String
    let categoryName: String
    let startTime: Date
    let endTime: Date
    let capacityMax: Int
    let subscriberNumber: Int
    let status: String

    var availablePlaces: Int {
        max(0, capacityMax - subscriberNumber)
    }
}

struct CreateReservationRequest: Encodable, Sendable {
    let userID: UUID
    let workshopID: UUID
    let status: String
}

struct UpdateReservationRequest: Encodable, Sendable {
    let status: String
}
