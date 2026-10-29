//
//  Workshop.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

struct Workshop: Codable, Identifiable, Sendable {
    let id: UUID
    let name: String
    let categoryName: String
    let startTime: Date
    let endTime: Date
    let capacityMax: Int
    let description: String
    let subscriberNumber: Int

    var availablePlaces: Int {
        max(0, capacityMax - subscriberNumber)
    }

    var hasAvailablePlaces: Bool {
        availablePlaces > 0
    }
    
    var formattedTime: String {
        let start = startTime.formatted(date: .omitted, time: .shortened)
        let end = endTime.formatted(date: .omitted, time: .shortened)

        return "\(start) – \(end)"
    }
    
    var formattedDate: String {
        startTime.formatted(.dateTime.month(.wide).day().locale(Locale(identifier: "en_US")))
    }
}
