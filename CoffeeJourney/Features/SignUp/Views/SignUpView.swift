//
//  SignUpView.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SignUpViewModel

    init(container: AppContainer) {
        _viewModel = State(
            initialValue: SignUpViewModel(
                authService: container.authService
            )
        )
    }

    var body: some View {
        Form {
            TextField("Nom", text: $viewModel.name)
                .textContentType(.name)

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            SecureField("Mot de passe", text: $viewModel.password)
                .textContentType(.newPassword)

            SecureField(
                "Confirmer le mot de passe",
                text: $viewModel.confirmPassword
            )
            .textContentType(.newPassword)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }

            Button {
                Task {
                    await viewModel.signUp()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Créer mon compte")
                }
            }
            .disabled(viewModel.isLoading)

            if viewModel.isRegistered {
                Section {
                    Text("Compte créé. Tu peux maintenant te connecter.")
                        .foregroundStyle(.green)

                    Button("Retour à la connexion") {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Inscription")
    }
}

#Preview {
    NavigationStack {
        SignUpView(container: AppContainer())
    }
}
