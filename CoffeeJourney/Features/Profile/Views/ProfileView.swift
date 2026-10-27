//
//  ProfileView.swift
//  CoffeeJourney
//
//  Created by Issa on 07/09/2026.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModel

    var body: some View {
        List {
            if let user = viewModel.user {
                LabeledContent("Nom", value: user.name)
                LabeledContent("Email", value: user.email)
                LabeledContent("Rôle", value: user.role)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }

            Button("Se déconnecter", role: .destructive) {
                viewModel.signOut()
            }
        }
        .navigationTitle("Profile")
        .overlay {
            if viewModel.isLoading {
                ProgressView("Chargement du profil…")
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview("Profile - Connecté") {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        ProfileView(
            viewModel: ProfileViewModel(
                service: container.profileService,
                sessionManager: container.sessionManager
            )
        )
    }
}

#Preview("Profile - Déconnecté") {
    let sessionManager = SessionManager(
        forceLoggedOut: true
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        ProfileView(
            viewModel: ProfileViewModel(
                service: container.profileService,
                sessionManager: container.sessionManager
            )
        )
    }
}
