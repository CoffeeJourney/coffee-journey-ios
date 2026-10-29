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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                AuthHeader(subtitle: "Welcome back!")
                    .padding(.top, 62)

                VStack(spacing: 12) {
                    TextField(
                        "",
                        text: $viewModel.email,
                        prompt: Text("Email")
                            .foregroundColor(AuthStyle.placeholder)
                    )
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .authTextFieldStyle()

                    SecureField(
                        "",
                        text: $viewModel.password,
                        prompt: Text("Password")
                            .foregroundColor(AuthStyle.placeholder)
                    )
                    .textContentType(.password)
                    .submitLabel(.go)
                    .authTextFieldStyle()
                }
                .padding(.top, 36)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 12)
                }

                Button {
                    Task {
                        await viewModel.login()
                    }
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Log In")
                        }
                    }
                }
                .buttonStyle(AuthPrimaryButtonStyle())
                .disabled(viewModel.isLoading)
                .padding(.top, 24)

                Spacer(minLength: 40)

                HStack(spacing: 12) {
                    Text("Don't have an account?")
                        .font(.system(size: 13))
                        .foregroundStyle(AuthStyle.caramel)

                    NavigationLink {
                        SignUpView(container: container)
                    } label: {
                        Text("Sign up")
                    }
                    .buttonStyle(AuthSecondaryButtonStyle())
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, max(36, geometry.safeAreaInsets.bottom + 16))
            }
            .padding(.horizontal, 28)
            .frame(
                maxWidth: .infinity,
                minHeight: geometry.size.height,
                alignment: .top
            )
            .background(AuthStyle.background.ignoresSafeArea())
        }
        .background(AuthStyle.background.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview("Login - Déconnecté") {
    let sessionManager = SessionManager(forceLoggedOut: true)
    let container = AppContainer(sessionManager: sessionManager)

    NavigationStack {
        LoginView(container: container)
    }
}

#Preview("Login - Connecté") {
    let sessionManager = SessionManager(previewToken: "preview-token")
    let container = AppContainer(sessionManager: sessionManager)

    NavigationStack {
        LoginView(container: container)
    }
}
