//
//  MainTabView.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import SwiftUI

struct MainTabView: View {
    let container: AppContainer

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack {
                    HomeView(
                        viewModel: HomeViewModel(
                            workshopService: container.workshopService,
                            reservationService: container.reservationService,
                            profileService: container.profileService,
                            sessionManager: container.sessionManager
                        )
                    )
                }
            }

            Tab("Workshops", systemImage: "calendar") {
                NavigationStack {
                    WorkshopsView(container: container)
                }
            }

            Tab("My Planning", systemImage: "ticket") {
                NavigationStack {
                    ReservationsView(
                        viewModel: ReservationsViewModel(
                            reservationService: container.reservationService,
                            workshopService: container.workshopService
                        )
                    )
                }
            }

            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileView(
                        viewModel: ProfileViewModel(
                            service: container.profileService,
                            sessionManager: container.sessionManager
                        )
                    )
                }
            }
        }
    }
}

#Preview("MainTab - Connecté") {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    MainTabView(container: container)
}
