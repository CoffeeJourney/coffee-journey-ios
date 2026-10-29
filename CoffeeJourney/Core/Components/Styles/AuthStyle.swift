//
//  AuthStyle.swift
//  CoffeeJourney
//
//  Created by morealcode on 29/10/2026.
//

import SwiftUI

enum AuthStyle {
    static let background = Color(
        red: 1.00,
        green: 0.93,
        blue: 0.85
    )

    static let fieldBackground = Color(
        red: 1.00,
        green: 0.97,
        blue: 0.93
    )

    static let brown = Color(
        red: 0.34,
        green: 0.17,
        blue: 0.02
    )

    static let caramel = Color(
        red: 0.67,
        green: 0.39,
        blue: 0.22
    )

    static let placeholder = Color(
        red: 0.67,
        green: 0.56,
        blue: 0.44
    )

    static let border = Color(
        red: 0.83,
        green: 0.53,
        blue: 0.34
    )
}

struct AuthTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .foregroundStyle(AuthStyle.brown)
            .padding(.horizontal, 16)
            .frame(height: 53)
            .background(AuthStyle.fieldBackground)
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .overlay {
                RoundedRectangle(cornerRadius: 13)
                    .stroke(AuthStyle.border, lineWidth: 1)
            }
    }
}

extension View {
    func authTextFieldStyle() -> some View {
        modifier(AuthTextFieldStyle())
    }
}

struct AuthHeader: View {
    let subtitle: String

    var body: some View {
        VStack(spacing: 0) {

            Image("LogoMark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(1.5)
                .foregroundStyle(.white)

            Text("Coffee Journey")
                .font(.system(size: 27, weight: .bold, design: .serif))
                .foregroundStyle(AuthStyle.brown)
                .padding(.top, 26)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundStyle(AuthStyle.caramel)
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AuthPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                AuthStyle.brown.opacity(configuration.isPressed ? 0.82 : 1)
            )
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct AuthSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(AuthStyle.brown)
            .padding(.horizontal, 19)
            .frame(height: 40)
            .background(
                AuthStyle.background.opacity(configuration.isPressed ? 0.7 : 1)
            )
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(AuthStyle.brown, lineWidth: 1)
            }
    }
}
