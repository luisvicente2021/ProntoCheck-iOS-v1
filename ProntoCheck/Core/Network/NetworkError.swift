//
//  NetworkError.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//


import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case encodingError
}