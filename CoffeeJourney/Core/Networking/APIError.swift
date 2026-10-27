//
//  APIError.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case httpStatus(Int, String)
    case decodingFailed
    case missingToken

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "L'URL de la requête est invalide."
        case .invalidResponse:
            return "La réponse du serveur est invalide."
        case .unauthorized:
            return "Session expirée. Veuillez vous reconnecter."
        case let .httpStatus(status, message):
            return "Erreur serveur (\(status)) : \(message)"
        case .decodingFailed:
            return "Impossible de lire les données du serveur."
        case .missingToken:
            return "Aucun jeton d'authentification disponible."
        }
    }
}
