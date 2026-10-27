//
//  WorkshopService.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

@MainActor
protocol WorkshopServicing {
    func fetchWorkshops() async throws -> [Workshop]
    func fetchWorkshop(id: UUID) async throws -> Workshop
}

@MainActor
final class WorkshopService: WorkshopServicing {
    private let api: APIClient

    init(api: APIClient) {
        self.api = api
    }

    func fetchWorkshops() async throws -> [Workshop] {
        let data = try await api.send(
            path: "/workshop"
        )

        return try APIJSON.makeDecoder().decode(
            [Workshop].self,
            from: data
        )
    }

    func fetchWorkshop(id: UUID) async throws -> Workshop {
        let data = try await api.send(
            path: "/workshop/\(id.uuidString)"
        )

        return try APIJSON.makeDecoder().decode(
            Workshop.self,
            from: data
        )
    }
}
