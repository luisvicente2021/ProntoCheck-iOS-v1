
import Foundation


protocol EmployeeRepositoryProtocol {
    func fetchEmployees() async throws -> [Employee]
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
}
