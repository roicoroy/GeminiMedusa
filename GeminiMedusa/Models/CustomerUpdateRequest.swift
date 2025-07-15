import Foundation

struct CustomerUpdateRequest: Codable {
    let firstName: String?
    let lastName: String?
    let phone: String?
    let companyName: String?
    
    enum CodingKeys: String, CodingKey {
        case phone
        case firstName = "first_name"
        case lastName = "last_name"
        case companyName = "company_name"
    }
}
