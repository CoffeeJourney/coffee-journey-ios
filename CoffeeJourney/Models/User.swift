//
//  User.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import Foundation

struct User: Codable, Identifiable, Sendable {
    let id: UUID
    let name: String
    let email: String
    let role: String
}

struct CreateUserRequest: Encodable, Sendable {
    let name: String
    let email: String
    let password: String
}

struct UpdateUserRequest: Encodable, Sendable {
    var name: String?
    var email: String?
    var password: String?
}
