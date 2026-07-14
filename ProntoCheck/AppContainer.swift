//
//  AppContainer.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//


final class AppContainer {
    
    @MainActor
    lazy var sessionManager = SessionManager()
    
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
    
    lazy var attendanceRepository: AttendanceRepositoryProtocol = {
        AttendanceRepository(networkService: networkService)
    }()
    
    @MainActor
    lazy var authViewModel: AuthViewModel = {
        AuthViewModel(
            repository: authRepository, sessionManager: sessionManager
        )
    }()
    
    @MainActor
    lazy var attendanceViewModel: AttendanceViewModel = {
        AttendanceViewModel(
            repository: attendanceRepository
        )
    }()
    
    
     @MainActor
     lazy var timeClockViewModel: TimeClockViewModel = {
         TimeClockViewModel()
     }()
 
}
