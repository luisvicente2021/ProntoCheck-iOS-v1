
import Foundation


protocol EmployeeRepositoryProtocol {
    func fetchEmployees() async throws -> [Employee]
    func updateFaceEmbedding(employeeId: UUID, embedding: [Float]) async throws -> Employee
}


final class EmployeeRepository: EmployeeRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchEmployees() async throws -> [Employee] {
        try await networkService.request(
            endpoint: EmployeeEndpoint.fetchEmployees
        )
    }
    
    func updateFaceEmbedding(employeeId: UUID, embedding: [Float]) async throws -> Employee {
            let request = UpdateFaceEmbeddingRequest(
                faceEmbeddingIOS: embedding
            )

            let response: [Employee] = try await networkService.request(
                endpoint: EmployeeEndpoint.updateFaceEmbedding(
                    employeeId: employeeId,
                    request: request
                )
            )

            guard let updatedEmployee = response.first else {
                throw EmployeeRepositoryError.emptyUpdateResponse
            }

            return updatedEmployee
        }
}

enum EmployeeRepositoryError: LocalizedError {
    case emptyUpdateResponse

    var errorDescription: String? {
        switch self {
        case .emptyUpdateResponse:
            return "Supabase no devolvió el empleado actualizado."
        }
    }
}
