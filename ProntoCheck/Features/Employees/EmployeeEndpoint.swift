import Foundation

enum EmployeeEndpoint: Endpoint {

    case fetchEmployees

    case updateFaceEmbedding(
        employeeId: UUID,
        request: UpdateFaceEmbeddingRequest
    )

    var basePath: String {
        "/rest/v1/"
    }

    var path: String {
        "empleados"
    }

    var method: HTTPMethod {
        switch self {
        case .fetchEmployees:
            return .get

        case .updateFaceEmbedding:
            return .patch
        }
    }

    var body: Data? {
        switch self {
        case .fetchEmployees:
            return nil

        case .updateFaceEmbedding(_, let request):
            do {
                let data = try JSONEncoder().encode(request)

                #if DEBUG
                print(
                    "✅ PATCH body:",
                    String(data: data, encoding: .utf8) ?? "Invalid body"
                )
                #endif

                return data
            } catch {
                #if DEBUG
                print("❌ Encoding face embedding request:", error)
                #endif

                return nil
            }
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchEmployees:
            return [
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "activo", value: "eq.true")
            ]

        case .updateFaceEmbedding(let employeeId, _):
            return [
                URLQueryItem(
                    name: "id",
                    value: "eq.\(employeeId.uuidString.lowercased())"
                ),
                URLQueryItem(
                    name: "select",
                    value: "*"
                )
            ]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .fetchEmployees:
            return nil

        case .updateFaceEmbedding:
            return [
                "Prefer": "return=representation"
            ]
        }
    }
}
