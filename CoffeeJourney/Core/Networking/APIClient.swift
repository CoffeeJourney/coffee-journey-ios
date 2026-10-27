//
//  APIClient.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

@MainActor
final class APIClient {
    private let configuration: APIConfiguration
    private let sessionManager: SessionManager
    private let session: URLSession

    init(
        configuration: APIConfiguration,
        sessionManager: SessionManager,
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.sessionManager = sessionManager
        self.session = session
    }

    func send(
        path: String,
        method: String = "GET",
        body: Data? = nil,
        authenticated: Bool = false
    ) async throws -> Data {
        let url = try configuration.url(for: path)

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        if body != nil {
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        }

        if authenticated {
            guard let token = sessionManager.token else {
                throw APIError.missingToken
            }

            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }

            let message = String(
                data: data,
                encoding: .utf8
            ) ?? "Erreur inconnue"

            throw APIError.httpStatus(
                httpResponse.statusCode,
                message
            )
        }

        return data
    }
}
