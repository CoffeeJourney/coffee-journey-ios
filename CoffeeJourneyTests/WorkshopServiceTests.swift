//
//  WorkshopServiceTests.swift
//  CoffeeJourneyTests
//
//  Created by morealcode on 28/10/2026.
//

import Foundation
import XCTest

@testable import CoffeeJourney

// Simule les réponses HTTP sans appeler le vrai serveur.
final class MockURLProtocol: URLProtocol {

    // Définit la réponse à renvoyer pour chaque requête.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    // Intercepte toutes les requêtes.
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    // Retourne la requête sans la modifier.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest
    {
        request
    }

    // Exécute le mock et transmet sa réponse à URLSession.
    override func startLoading() {
        guard let handler = Self.requestHandler else {
            client?.urlProtocol(
                self,
                didFailWithError: URLError(.badServerResponse)
            )
            return
        }

        do {
            let (response, data) = try handler(request)

            // Transmet la réponse HTTP et les données reçues.
            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // Signale l'erreur à URLSession.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    // Aucune opération à effectuer pour arrêter le mock.
    override func stopLoading() {}
}

@MainActor
final class WorkshopServiceTests: XCTestCase {

    private var service: WorkshopService!

    // Identifiant fixe pour rendre les tests reproductibles.
    private let workshopID = UUID(
        uuidString: "B21FF0E6-1E0E-42BD-97B4-D39E816B9E29"
    )!

    // Prépare le service avec une session réseau simulée.
    override func setUp() {
        super.setUp()

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]

        let session = URLSession(configuration: sessionConfiguration)
        let sessionManager = SessionManager(forceLoggedOut: true)

        let apiClient = APIClient(
            configuration: APIConfiguration(
                baseURL: URL(string: "http://localhost:8081")!
            ),
            sessionManager: sessionManager,
            session: session
        )

        service = WorkshopService(api: apiClient)
    }

    // Nettoie les données après chaque test.
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        service = nil
        super.tearDown()
    }

    // Construit une réponse HTTP contenant du JSON.
    private func makeResponse(
        for request: URLRequest,
        statusCode: Int = 200,
        json: String
    ) -> (HTTPURLResponse, Data) {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!

        return (response, Data(json.utf8))
    }

    // Vérifie que la liste des workshops est correctement décodée.
    func testFetchWorkshopsReturnsDecodedList() async throws {
        let json = """
            [
                {
                    "id": "\(workshopID.uuidString)",
                    "description": "Learn to dial in an espresso machine, adjust grind size and extract a balanced shot.",
                    "startTime": "2026-11-04T08:00:00Z",
                    "subscriberNumber": 5,
                    "categoryName": "Barista",
                    "capacityMax": 16,
                    "name": "Espresso Fundamentals",
                    "endTime": "2026-11-04T09:30:00Z"
                }
            ]
            """

        // Simule une réponse réussie à GET /workshop.
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.path, "/workshop")
            XCTAssertEqual(request.httpMethod, "GET")

            return self.makeResponse(for: request, json: json)
        }

        let workshops = try await service.fetchWorkshops()

        // Vérifie le contenu de la liste reçue.
        XCTAssertEqual(workshops.count, 1)
        XCTAssertEqual(workshops.first?.id, workshopID)
        XCTAssertEqual(workshops.first?.name, "Espresso Fundamentals")
        XCTAssertEqual(workshops.first?.categoryName, "Barista")
        XCTAssertEqual(workshops.first?.capacityMax, 16)
    }

    // Vérifie que le détail d'un workshop est correctement décodé.
    func testFetchWorkshopReturnsDecodedWorkshop() async throws {
        let json = """
            {
                "id": "\(workshopID.uuidString)",
                "description": "Learn to dial in an espresso machine, adjust grind size and extract a balanced shot.",
                "startTime": "2026-11-04T08:00:00Z",
                "subscriberNumber": 5,
                "categoryName": "Barista",
                "capacityMax": 16,
                "name": "Espresso Fundamentals",
                "endTime": "2026-11-04T09:30:00Z"
            }
            """

        // Simule une réponse réussie à GET /workshop/:id.
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(
                request.url?.path,
                "/workshop/\(self.workshopID.uuidString)"
            )

            return self.makeResponse(for: request, json: json)
        }

        let workshop = try await service.fetchWorkshop(id: workshopID)

        // Vérifie les propriétés du workshop retourné.
        XCTAssertEqual(workshop.id, workshopID)
        XCTAssertEqual(workshop.name, "Espresso Fundamentals")
        XCTAssertEqual(workshop.subscriberNumber, 5)
    }

    // Vérifie qu'un JSON invalide provoque une erreur de décodage.
    func testFetchWorkshopsThrowsForInvalidJSON() async {
        MockURLProtocol.requestHandler = { request in
            self.makeResponse(for: request, json: "{ invalid json")
        }

        do {
            _ = try await service.fetchWorkshops()
            XCTFail("Une erreur de décodage était attendue.")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    // Vérifie que le service propage une erreur HTTP 500.
    func testFetchWorkshopsThrowsForHTTP500() async {
        MockURLProtocol.requestHandler = { request in
            self.makeResponse(
                for: request,
                statusCode: 500,
                json: #"{"error":"Internal Server Error"}"#
            )
        }

        do {
            _ = try await service.fetchWorkshops()
            XCTFail("Une erreur HTTP 500 était attendue.")
        } catch let error as APIError {
            // Vérifie que le code d'erreur est bien 500.
            guard case .httpStatus(500, _) = error else {
                XCTFail("Erreur inattendue : \(error)")
                return
            }
        } catch {
            XCTFail("Type d'erreur inattendu : \(error)")
        }
    }
}
