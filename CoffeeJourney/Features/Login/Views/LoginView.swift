//
//  LoginView.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import SwiftUI

struct LoginView: View {
    let container: AppContainer

    @State private var viewModel: LoginViewModel

    init(container: AppContainer) {
        self.container = container
        _viewModel = State(
            initialValue: LoginViewModel(
                authService: container.authService,
                sessionManager: container.sessionManager
            )
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("CoffeeFestival")
                .font(.largeTitle.bold())

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Mot de passe", text: $viewModel.password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Button {
                Task {
                    await viewModel.login()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Se connecter")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)

            NavigationLink("Créer un compte") {
                SignUpView(container: container)
            }
        }
        .padding()
        .navigationTitle("Connexion")
    }
}

#Preview("Login - Déconnecté") {
    let sessionManager = SessionManager(
        forceLoggedOut: true
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        LoginView(container: container)
    }
}

#Preview("Login - Connecté") {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )
    let container = AppContainer(
        sessionManager: sessionManager
    )

    NavigationStack {
        LoginView(container: container)
    }
}
