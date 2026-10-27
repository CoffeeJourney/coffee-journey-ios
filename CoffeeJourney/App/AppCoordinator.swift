//
//  AppCoordinator.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import SwiftUI

struct AppCoordinator: View {
    let container: AppContainer

    var body: some View {
        Group {
            if container.sessionManager.isAuthenticated {
                MainTabView(container: container)
            } else {
                NavigationStack {
                    LoginView(container: container)
                }
            }
        }
        .animation(
            .default,
            value: container.sessionManager.isAuthenticated
        )
    }
}

#Preview("Connecté") {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    AppCoordinator(container: container)
}

#Preview("Login - Déconnecté") {
    let sessionManager = SessionManager(
        forceLoggedOut: true
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    AppCoordinator(container: container)
}
