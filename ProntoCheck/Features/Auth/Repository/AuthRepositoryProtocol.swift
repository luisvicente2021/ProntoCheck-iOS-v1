protocol AuthRepositoryProtocol {
    func login(
        email: String,
        password: String
    ) async throws -> AuthResponse
}