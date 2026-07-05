//
//  AuthViewModel.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//
import Foundation
import CoreLocation
import UIKit


    @MainActor
    final class AuthViewModel: ObservableObject {

        @Published var email = ""
        @Published var password = ""
        @Published var isLoading = false
        @Published var errorMessage: String?
        @Published var isAuthenticated = false

        private let repository: AuthRepositoryProtocol

        init(repository: AuthRepositoryProtocol) {
            self.repository = repository
        }

        func login() async {
            isLoading = true
            errorMessage = nil

            do {
                let response = try await repository.login(
                    email: email,
                    password: password
                )

                isAuthenticated = true
                print("Token:", response.accessToken)

            } catch {
                errorMessage = "No se pudo iniciar sesión"
            }

            isLoading = false
        }
    }
