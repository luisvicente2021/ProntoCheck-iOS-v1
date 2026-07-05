//
//  SessionManager.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//


import Foundation

@MainActor
final class SessionManager: ObservableObject {

    @Published private(set) var authResponse: AuthResponse?
    @Published private(set) var isAuthenticated = false

    func saveSession(_ response: AuthResponse) {
        self.authResponse = response
        self.isAuthenticated = true

        // Temporal mientras pruebas
        print("Sesión guardada para:", response.user.email)
    }

    func logout() {
        self.authResponse = nil
        self.isAuthenticated = false
    }

    var accessToken: String? {
        authResponse?.accessToken
    }

    var currentUser: AuthUser? {
        authResponse?.user
    }
}