import Foundation

struct AuthUser: Decodable {
    let id: UUID
    let email: String?
}