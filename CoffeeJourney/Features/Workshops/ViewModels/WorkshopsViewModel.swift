//
//  WorkshopsViewModel.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation
import Observation
import SwiftUI

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
            workshops.sort { $0.startTime < $1.startTime }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var categories: [String] {
        var categories = ["All"]

        for workshop in workshops {
            if !categories.contains(workshop.categoryName) {
                categories.append(workshop.categoryName)
            }
        }
        return categories
    }
    
    func filteredWorkshops(for category: String) -> [Workshop] {
        if category == "All" {
            return workshops
        }

        return workshops.filter { workshop in
            workshop.categoryName == category
        }
    }
    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Barista", "Barista de fou", "Pastry":
            return "cup.and.saucer"
        case "Coffee Culture":
            return "book"
        case "Filter Coffee":
            return "drop"
        case "Latte Art":
            return "heart"
        case "Roasting":
            return "flame"
        case "Tasting":
            return "leaf"
        case "World Coffee":
            return "globe.europe.africa"
        default:
            return "cup.and.saucer"
        }
    }
    
    func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Barista":
            return .secondaryBrown.opacity(0.25)
        case "Tasting":
            return .secondaryGreen
        case "Pastry":
            return .secondaryBackground
        case "Roasting":
            return .primaryGreen.opacity(0.25)
        case "Latte Art":
            return .secondaryGreen
        default:
            return .secondaryBackground
        }
    }
}
