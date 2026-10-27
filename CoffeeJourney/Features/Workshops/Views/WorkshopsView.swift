//
//  WorkshopsView.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import SwiftUI

struct WorkshopsView: View {
    let container: AppContainer

    @State private var viewModel: WorkshopsViewModel

    init(container: AppContainer) {
        self.container = container

        _viewModel = State(
            initialValue: WorkshopsViewModel(
                service: container.workshopService
            )
        )
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView {
                    Label(
                        "Impossible de charger les ateliers",
                        systemImage: "exclamationmark.triangle"
                    )
                } description: {
                    Text(error)
                } actions: {
                    Button("Réessayer") {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
            } else {
                List(viewModel.workshops) { workshop in
                    NavigationLink {
                        WorkshopDetailView(
                            workshopID: workshop.id,
                            viewModel: WorkshopDetailViewModel(
                                workshopService: container.workshopService,
                                reservationService: container.reservationService,
                                profileService: container.profileService,
                                sessionManager: container.sessionManager
                            )
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(workshop.name)
                                .font(.headline)

                            Text(workshop.categoryName)
                                .foregroundStyle(.secondary)

                            Text(
                                "\(workshop.availablePlaces) place(s) disponible(s)"
                            )
                            .font(.caption)
                            .foregroundStyle(
                                workshop.hasAvailablePlaces ? .green : .secondary
                            )
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Workshops")
        .task {
            await viewModel.load()
        }
    }
}

#Preview("Workshops - Déconnecté") {
    let sessionManager = SessionManager(
        forceLoggedOut: true
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        WorkshopsView(container: container)
    }
}

#Preview("Workshops - Connecté") {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        WorkshopsView(container: container)
    }
}
