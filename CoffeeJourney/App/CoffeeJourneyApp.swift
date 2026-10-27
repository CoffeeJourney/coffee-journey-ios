//
//  CoffeeJourneyApp.swift
//  CoffeeJourney
//
//  Created by Issa on 02/09/2026.
//

import SwiftUI

@main
struct CoffeeJourneyApp: App {
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            AppCoordinator(container: container)
        }
    }
}
