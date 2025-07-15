import Foundation

struct CustomerLoginRequest: Codable {
    let email: String
    let password: String
}