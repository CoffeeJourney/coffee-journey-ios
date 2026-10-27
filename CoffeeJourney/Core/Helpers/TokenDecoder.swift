//
//  TokenDecoder.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

enum TokenDecoder {
    static func decode(_ data: Data) throws -> String {
        guard let raw = String(
            data: data,
            encoding: .utf8
        ) else {
            throw APIError.decodingFailed
        }

        let trimmed = raw.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // Cas 1 : réponse JSON de type "eyJ..."
        if trimmed.hasPrefix("\""),
           let decoded = try? JSONDecoder().decode(
               String.self,
               from: data
           ) {
            return decoded
        }

        // Cas 2 : réponse texte brut eyJ...
        guard !trimmed.isEmpty else {
            throw APIError.missingToken
        }

        return trimmed
    }
}
