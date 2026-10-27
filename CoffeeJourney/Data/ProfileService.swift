//
//  ProfileService.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

@MainActor
protocol ProfileServicing {
    func fetchProfile() async throws -> User
    func fetchUser(id: UUID) async throws -> User
    func updateUser(
        id: UUID,
        request: UpdateUserRequest
    ) async throws
    func deleteUser(id: UUID) async throws
}

@MainActor
final class ProfileService: ProfileServicing {
    private let api: APIClient

    private let profilePath = "user/profile"

    init(api: APIClient) {
        self.api = api
    }

    func fetchProfile() async throws -> User {
        let data = try await api.send(
            path: profilePath,
            authenticated: true
        )

        return try APIJSON.makeDecoder().decode(
            User.self,
            from: data
        )
    }

    func fetchUser(id: UUID) async throws -> User {
        let data = try await api.send(
            path: "/user/\(id.uuidString)",
            authenticated: true
        )

        return try APIJSON.makeDecoder().decode(
            User.self,
            from: data
        )
    }

    func updateUser(
        id: UUID,
        request: UpdateUserRequest
    ) async throws {
        let body = try APIJSON.makeEncoder().encode(request)

        _ = try await api.send(
            path: "/user/\(id.uuidString)",
            method: "PUT",
            body: body,
            authenticated: true
        )
    }

    func deleteUser(id: UUID) async throws {
        _ = try await api.send(
            path: "/user/\(id.uuidString)",
            method: "DELETE",
            authenticated: true
        )
    }
}
