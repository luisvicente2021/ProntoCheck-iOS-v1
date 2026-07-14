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
    
    lazy var faceEmbeddingProvider: FaceEmbeddingProviderProtocol = {
        do {
            return try ArcFaceEmbeddingProvider()
        } catch {
            fatalError(
                "No se pudo inicializar el modelo FaceEmbedding: \(error)"
            )
        }
    }()
    
    lazy var faceRecognitionService: FaceRecognitionServiceProtocol = {
        
        FaceRecognitionService(embeddingProvider: faceEmbeddingProvider, recognitionThreshold: 1.0)
        
    }()
    
    lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository(
            networkService: networkService
        )
    }()
    
    lazy var attendanceRepository: AttendanceRepositoryProtocol = {
        AttendanceRepository(networkService: networkService)
    }()
    
    lazy var employeeRepository: EmployeeRepositoryProtocol = {
        EmployeeRepository(networkService: networkService)
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
        TimeClockViewModel(employeeRepository: employeeRepository, faceRecognitionService: faceRecognitionService)
    }()
    
    @MainActor
    lazy var employeeFaceEnrollmentViewModel:
    EmployeeFaceEnrollmentViewModel = {
        
        EmployeeFaceEnrollmentViewModel(
            employeeRepository: employeeRepository,
            faceRecognitionService: faceRecognitionService)
    }()
}
