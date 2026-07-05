//
//  AttendanceEndpoint.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//

import Foundation


enum AttendanceEndpoint: Endpoint {

    case register(RegisterAttendanceRequest)
    case history(employeeId: UUID)
    case lastAttendance(employeeId: UUID)

    var basePath: String {
        "/rest/v1/"
    }

    var path: String {
        "asistencia"
    }

    var method: HTTPMethod {
        switch self {
        case .register:
            return .post

        case .history,
             .lastAttendance:
            return .get
        }
    }

    var body: Data? {
        switch self {
        case .register(let request):
            return try? JSONEncoder().encode(request)

        case .history,
             .lastAttendance:
            return nil
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .register:
            return nil

        case .history(let employeeId):
            return [
                URLQueryItem(name: "empleado_id", value: "eq.\(employeeId.uuidString)"),
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "order", value: "fecha_hora.desc")
            ]

        case .lastAttendance(let employeeId):
            return [
                URLQueryItem(name: "empleado_id", value: "eq.\(employeeId.uuidString)"),
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "order", value: "fecha_hora.desc"),
                URLQueryItem(name: "limit", value: "1")
            ]
        }
    }
}
