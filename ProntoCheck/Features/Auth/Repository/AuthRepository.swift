//
//  AuthRepository.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(
            email: email,
            password: password
        )

        let endpoint = AuthEndpoint.login(request)

        return try await networkService.request(endpoint: endpoint)
    }
}
