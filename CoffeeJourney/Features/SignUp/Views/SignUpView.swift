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
                authService: container.authService,
                sessionManager: container.sessionManager
            )
        )
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                AuthHeader(
                    subtitle: "Your coffee adventure starts here."
                )
                .padding(.top, 62)

                VStack(spacing: 12) {
                    TextField(
                        "",
                        text: $viewModel.name,
                        prompt: Text("Full name")
                            .foregroundColor(AuthStyle.placeholder)
                    )
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.next)
                    .authTextFieldStyle()

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
                    .textContentType(.newPassword)
                    .submitLabel(.next)
                    .authTextFieldStyle()

                    SecureField(
                        "",
                        text: $viewModel.confirmPassword,
                        prompt: Text("Confirm password")
                            .foregroundColor(AuthStyle.placeholder)
                    )
                    .textContentType(.newPassword)
                    .submitLabel(.go)
                    .authTextFieldStyle()
                }
                .padding(.top, 32)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 12)
                }

                if viewModel.isRegistered {
                    Text("Account created. You can now log in.")
                        .font(.footnote)
                        .foregroundStyle(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 12)

                    Button("Back to Log In") {
                        dismiss()
                    }
                    .foregroundStyle(AuthStyle.brown)
                    .padding(.top, 8)
                } else {
                    Button {
                        Task {
                            await viewModel.signUp()
                        }
                    } label: {
                        Group {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else if viewModel.isAccountCreated {
                                Text("Retry connection")
                            } else {
                                Text("Create account")
                            }
                        }
                    }
                    .buttonStyle(AuthPrimaryButtonStyle())
                    .disabled(viewModel.isLoading)
                    .padding(.top, 28)
                }

                Spacer(minLength: 40)

                HStack(spacing: 12) {
                    Text("Already have an account?")
                        .font(.system(size: 13))
                        .foregroundStyle(AuthStyle.caramel)

                    Button("Log In") {
                        dismiss()
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

#Preview("Sign Up") {
    NavigationStack {
        SignUpView(container: AppContainer())
    }
}
