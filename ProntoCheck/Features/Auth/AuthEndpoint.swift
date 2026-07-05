//
//  AuthEndpoint.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//

import Foundation

enum AuthEndpoint: Endpoint {
    var queryItems: [URLQueryItem]? {
        switch self {
        case .login:
            return [
                URLQueryItem(name: "grant_type", value: "password")
            ]
        }
    }
    
    case login(LoginRequest)

    var basePath: String {
        "/auth/v1/"
    }

    var path: String {
        switch self {
        case .login:
            return  "token"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }

    var body: Data? {
        switch self {
        case .login(let request):
            return try? JSONEncoder().encode(request)
        }
    }
}
