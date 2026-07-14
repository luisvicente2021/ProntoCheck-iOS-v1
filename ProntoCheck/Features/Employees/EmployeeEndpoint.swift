//  Created by luisr on 12/07/26.
//
//  EmployeeEndpoint.swift
//  ProntoCheck
//

import Foundation

enum EmployeeEndpoint: Endpoint {

    case fetchEmployees

    var basePath: String {
        "/rest/v1/"
    }

    var path: String {
        switch self {
        case .fetchEmployees:
            return "empleados"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchEmployees:
            return .get
        }
    }

    var body: Data? {
        nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchEmployees:
            return [
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "activo", value: "eq.true")
            ]
        }
    }
}
