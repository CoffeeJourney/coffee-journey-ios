//
//  AuthService.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let password: String
}

@MainActor

protocol AuthServicing {
    func login(email: String, password: String) async throws -> String
    func signUp(name: String, email: String, password: String) async throws
}

@MainActor
final class AuthService: AuthServicing {
    private let api: APIClient

    init(api: APIClient) {
        self.api = api
    }

    func login(
        email: String,
        password: String
    ) async throws -> String {
        let body = try JSONEncoder().encode(
            LoginRequest(
                email: email,
                password: password
            )
        )

        let data = try await api.send(
            path: "/user/login",
            method: "POST",
            body: body
        )

        return try TokenDecoder.decode(data)
    }

    func signUp(
        name: String,
        email: String,
        password: String,
    ) async throws {
        let body = try JSONEncoder().encode(
            SignUpRequest(
                name: name,
                email: email,
                password: password
            )
        )

        _ = try await api.send(
            path: "/user",
            method: "POST",
            body: body
        )
    }
}
