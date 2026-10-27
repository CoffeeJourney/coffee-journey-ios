//
//  APIConfiguration.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

struct APIConfiguration: Sendable {
    let baseURL: URL

    static let development = APIConfiguration(
        baseURL: URL(string: "http://localhost:8081")!
    )

    func url(for path: String) throws -> URL {
        guard let url = URL(
            string: path,
            relativeTo: baseURL
        )?.absoluteURL else {
            throw APIError.invalidURL
        }

        return url
    }
}
