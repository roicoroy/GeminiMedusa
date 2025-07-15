import Foundation

struct DirectCustomerResponse: Codable {
    let id: String
    let email: String
    let defaultBillingAddressId: String?
    let defaultShippingAddressId: String?
    let companyName: String?
    let firstName: String?
    let lastName: String?
    let addresses: [Address]?
    let phone: String?
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, addresses, phone, token
        case defaultBillingAddressId = "default_billing_address_id"
        case defaultShippingAddressId = "default_shipping_address_id"
        case companyName = "company_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}
