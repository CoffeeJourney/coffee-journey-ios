//
//  ReservationsView.swift
//  CoffeeJourney
//
//  Created by Issa on 07/09/2026.
//

import SwiftUI

struct ReservationsView: View {
    @State var viewModel: ReservationsViewModel

    var body: some View {
        List {
            ForEach(viewModel.reservations) { reservation in
                VStack(alignment: .leading, spacing: 6) {
                    if let workshop = viewModel.workshop(for: reservation) {
                        Text(workshop.name)
                            .font(.headline)

                        Text(workshop.categoryName)
                            .foregroundStyle(.secondary)

                        Text(
                            workshop.startTime.formatted(
                                date: .abbreviated,
                                time: .shortened
                            )
                        )
                        .font(.subheadline)

                        Text(
                            "\(workshop.availablePlaces) place(s) disponible(s)"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    } else {
                        Text("Atelier introuvable")
                            .font(.headline)
                    }

                    Text("Statut : \(reservation.status)")
                        .foregroundStyle(.secondary)

                    Button("Annuler la réservation", role: .destructive) {
                        Task {
                            await viewModel.cancel(reservation)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("My Planning")
        .overlay {
            if viewModel.isLoading {
                ProgressView("Chargement des réservations…")
            } else if viewModel.reservations.isEmpty {
                ContentUnavailableView(
                    "Aucune réservation",
                    systemImage: "calendar",
                    description: Text("Tes ateliers réservés apparaîtront ici.")
                )
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView(
                    "Erreur",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
            }
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
    }
}

#Preview("Reservations - Connecté") {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        ReservationsView(
            viewModel: ReservationsViewModel(
                reservationService: container.reservationService,
                workshopService: container.workshopService
            )
        )
    }
}

#Preview("Reservations - Déconnecté") {
    let sessionManager = SessionManager(
        forceLoggedOut: true
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        ReservationsView(
            viewModel: ReservationsViewModel(
                reservationService: container.reservationService,
                workshopService: container.workshopService
            )
        )
    }
}
