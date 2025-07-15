import Foundation

struct CustomerCreationPayload: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case email, phone
        case firstName = "first_name"
        case lastName = "last_name"
    }
}