//
//  AppContainer.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//


final class AppContainer {

    lazy var networkService: NetworkServiceProtocol = {
        NetworkService(
            baseURL: AppConfiguration.baseURL,
            apiKey: AppConfiguration.apiKey
        )
    }()

    lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository(
            networkService: networkService
        )
    }()

    @MainActor
    lazy var authViewModel: AuthViewModel = {
        AuthViewModel(
            repository: authRepository
        )
    }()
}