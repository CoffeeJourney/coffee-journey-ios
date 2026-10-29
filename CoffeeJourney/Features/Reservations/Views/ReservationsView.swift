//
//  ReservationsView.swift
//  CoffeeJourney
//
//  Created by Issa on 07/09/2026.
//

import SwiftUI

struct ReservationsView: View {
    let container: AppContainer
    @State var viewModel: ReservationsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                PageHeaderView(
                    title: "My planning",
                    subtitle: "Your upcoming workshops",
                    showSearch: false
                )

                ForEach(viewModel.reservations) { reservation in
                    if let workshop = viewModel.workshop(for: reservation) {
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
                            WorkshopCardView(
                                title: workshop.name,
                                time: workshop.formattedTime,
                                location: "",
                                spotsLeft: workshop.availablePlaces,
                                icon: WorkshopsViewModel.iconForCategory(workshop.categoryName),
                                iconColor: .primaryBrown,
                                iconBackground: WorkshopsViewModel.colorForCategory(workshop.categoryName),
                                category: workshop.categoryName,
                                date: workshop.formattedDate,
                                reservationStatus: reservation.status
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        Text("Atelier introuvable")
                            .font(.headline)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .background(Color.primaryBackground.ignoresSafeArea())
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
            container: container,
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
            container: container,
            viewModel: ReservationsViewModel(
                reservationService: container.reservationService,
                workshopService: container.workshopService
            )
        )
    }
}
