//
//  AuthRepositoryProtocol.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//


protocol AuthRepositoryProtocol {
    func login(
        email: String,
        password: String
    ) async throws -> AuthResponse
}