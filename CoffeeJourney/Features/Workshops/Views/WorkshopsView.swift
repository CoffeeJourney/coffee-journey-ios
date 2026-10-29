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
    @State private var selectedCategory = "All"

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
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        PageHeaderView(
                            title: "Workshops",
                            subtitle: "Discover our workshops"
                        )

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button {
                                        selectedCategory = category
                                    } label: {
                                        HStack(spacing: 6) {
                                            if category != "All" {
                                                Image(systemName: WorkshopsViewModel.iconForCategory(category))
                                            }

                                            Text(category)
                                        }
                                        .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(
                                                selectedCategory == category ? .white : .primaryBrown
                                            )
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 12)
                                            .background(
                                                selectedCategory == category ? Color.primaryBrown : .clear
                                            )
                                            .clipShape(Capsule())
                                            .overlay {
                                                Capsule()
                                                    .stroke(.primaryBrown, lineWidth: 1)
                                            }
                                    }
                                }
                            }
                        }

                        LazyVStack(alignment: .leading, spacing: 12) {

                            let workshops = viewModel.filteredWorkshops(for: selectedCategory)

                            ForEach(workshops) { workshop in
                                VStack(alignment: .leading, spacing: 12) {

                                    if workshops.first(where: {
                                        $0.formattedDate == workshop.formattedDate
                                    })?.id == workshop.id {

                                        Text(workshop.formattedDate)
                                            .font(.headline)
                                            .foregroundStyle(.primaryGreen)
                                    }

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
                                            category: workshop.categoryName
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .background(Color.primaryBackground.ignoresSafeArea())
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
