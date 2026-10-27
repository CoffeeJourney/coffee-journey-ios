import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // En-tête
                HStack {
                    Text("Coffee Journey")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(.primaryBrown)

                    Spacer()
                }

                // Message d'accueil si connecté
                if let name = viewModel.userName {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hello, \(name) 👋")
                            .font(AppTypography.sectionTitle)
                            .foregroundStyle(.primaryBrown)

                        Text("Discover the world of coffee")
                            .foregroundStyle(.secondaryBrown)
                    }
                }

                // Bannière
                ZStack(alignment: .bottomLeading) {
                    Image("coffeeBanner")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("FROM BEAN TO CUP")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)

                        Text("Explore our workshops")
                            .font(.system(
                                size: 20,
                                weight: .regular,
                                design: .serif
                            ))
                            .foregroundStyle(.white)

                        NavigationLink {
                            WorkshopsView(
                                container: AppContainer()
                            )
                        } label: {
                            Text("Discover")
                                .font(.system(
                                    size: 14,
                                    weight: .semibold
                                ))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(.primaryGreen)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                    .padding(20)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipShape(.rect(cornerRadius: 22))

                // Prochains ateliers réservés
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Next Workshops")
                            .font(AppTypography.sectionTitle)
                            .foregroundStyle(.primaryBrown)

                        Spacer()
                    }

                    if viewModel.isLoading {
                        ProgressView("Loading your workshops…")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    } else if viewModel.nextWorkshops.isEmpty {
                        ContentUnavailableView(
                            "No upcoming workshops",
                            systemImage: "calendar",
                            description: Text(
                                "Your next reserved workshops will appear here."
                            )
                        )
                    } else {
                        ForEach(viewModel.nextWorkshops) { workshop in
                            WorkshopCardView(
                                title: workshop.name,
                                time: "\(workshop.startTime.formatted(date: .omitted, time: .shortened)) – \(workshop.endTime.formatted(date: .omitted, time: .shortened))",
                                location: workshop.categoryName,
                                spotsLeft: workshop.availablePlaces,
                                icon: "cup.and.saucer",
                                iconColor: .primaryBrown,
                                iconBackground: .secondaryBrown.opacity(0.25)
                            )
                        }
                    }
                }

                // Édition italienne
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "globe")
                        .font(.system(size: 24))
                        .foregroundStyle(.primaryGreen)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Two editions, one journey")
                            .font(.system(
                                size: 16,
                                weight: .bold,
                                design: .serif
                            ))
                            .foregroundStyle(.primaryGreen)

                        Text(
                            "Coffee Journey also takes place in Naples, Italy."
                        )
                        .font(.system(size: 12))
                        .foregroundStyle(.primaryGreen)

                        Text("Discover the Italian edition →")
                            .font(.system(size: 12, weight: .semibold))
                            .underline()
                            .foregroundStyle(.primaryGreen)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.secondaryGreen)
                .clipShape(.rect(cornerRadius: 20))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .background(.primaryBackground)
        .task {
            await viewModel.load()
        }
    }
}

#Preview("Home - Connecté") {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

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

#Preview("Home - Déconnecté") {
    let sessionManager = SessionManager(
        forceLoggedOut: true
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

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
