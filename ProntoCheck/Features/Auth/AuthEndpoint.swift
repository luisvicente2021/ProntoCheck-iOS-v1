//
//  AuthEndpoint.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case login(LoginRequest)

    var basePath: String {
        "/auth/v1"
    }

    var path: String {
        switch self {
        case .login:
            return "/token?grant_type=password"
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
