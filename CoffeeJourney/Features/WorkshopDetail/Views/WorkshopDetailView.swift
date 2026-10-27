//
//  WorkshopDetailView.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import SwiftUI

struct WorkshopDetailView: View {
    let workshopID: UUID
    @State var viewModel: WorkshopDetailViewModel

    var body: some View {
        Group {
            if let workshop = viewModel.workshop {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(workshop.name)
                            .font(.title.bold())

                        Text(workshop.categoryName)
                            .foregroundStyle(.secondary)

                        Text(workshop.description)

                        LabeledContent(
                            "Places disponibles",
                            value: "\(workshop.availablePlaces)"
                        )

                        LabeledContent(
                            "Début",
                            value: workshop.startTime.formatted(
                                date: .abbreviated,
                                time: .shortened
                            )
                        )

                        LabeledContent(
                            "Fin",
                            value: workshop.endTime.formatted(
                                date: .omitted,
                                time: .shortened
                            )
                        )

                        Button {
                            Task {
                                await viewModel.reserve()
                            }
                        } label: {
                            if viewModel.isBooking {
                                ProgressView()
                            } else {
                                Text("Réserver cet atelier")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!viewModel.canReserve)

                        if viewModel.hasAlreadyReserved {
                            Text("Tu as déjà réservé cet atelier.")
                                .foregroundStyle(.secondary)
                        }

                        if let message = viewModel.successMessage {
                            Text(message)
                                .foregroundStyle(.green)
                        }

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                }
            } else if viewModel.isLoading {
                ProgressView("Chargement de l'atelier…")
            } else {
                ContentUnavailableView(
                    "Atelier indisponible",
                    systemImage: "cup.and.saucer",
                    description: Text(
                        viewModel.errorMessage ?? "Aucune information disponible."
                    )
                )
            }
        }
        .navigationTitle("Workshop detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load(workshopID: workshopID)
        }
    }
}

#Preview {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )

    let container = AppContainer(
        sessionManager: sessionManager
    )

    let viewModel = WorkshopDetailViewModel(
        workshopService: container.workshopService,
        reservationService: container.reservationService,
        profileService: container.profileService,
        sessionManager: container.sessionManager
    )

    NavigationStack {
        WorkshopDetailView(
            workshopID: UUID(
                uuidString: "E8DEB22B-FB51-4FDA-B8D5-5E95E208E8CF" // à changer selon sa base de données
            )!,
            viewModel: viewModel
        )
    }
}
