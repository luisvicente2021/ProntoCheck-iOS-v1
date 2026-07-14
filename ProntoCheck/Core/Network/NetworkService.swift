//
//  NetworkService.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {

    private let baseURL: String
    private let apiKey: String
    private let session: URLSession

    init(
        baseURL: String,
        apiKey: String,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
    }

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard var components = URLComponents(string: baseURL + endpoint.basePath + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            #if DEBUG
            let responseBody = String(
                data: data,
                encoding: .utf8
            ) ?? "Respuesta sin contenido"

            print("❌ HTTP status:", httpResponse.statusCode)
            print("❌ Supabase response:", responseBody)
            print("❌ Request URL:", url.absoluteString)
            #endif

            throw NetworkError.serverError(
                statusCode: httpResponse.statusCode
            )
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("❌ Decoding error:", error)
            #endif

            throw NetworkError.decodingError
        }
    }
}
