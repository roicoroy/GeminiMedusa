import Foundation

struct AuthRegisterPayload: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String?
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case email, password, phone
        case firstName = "first_name"
        case lastName = "last_name"
    }
}