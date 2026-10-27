//
//  WorkshopsViewModel.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class WorkshopsViewModel {
    private(set) var workshops: [Workshop] = []
    private(set) var isLoading = false
    var errorMessage: String?

    private let service: any WorkshopServicing

    init(service: any WorkshopServicing) {
        self.service = service
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            workshops = try await service.fetchWorkshops()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
