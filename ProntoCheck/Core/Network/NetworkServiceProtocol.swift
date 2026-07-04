//
//  NetworkServiceProtocol.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}
