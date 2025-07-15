import Foundation

struct LoginResponse: Codable {
    let customer: Customer?
    let token: String?
    
    // Custom decoder to handle different response structures
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode token first
        self.token = try? container.decodeIfPresent(String.self, forKey: .token)
        
        // Try to decode customer from "customer" key first
        if let customerData = try? container.decodeIfPresent(Customer.self, forKey: .customer) {
            self.customer = customerData
        } else {
            // If that fails, try to decode the entire response as a Customer
            self.customer = try? Customer(from: decoder)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case customer, token
    }
}