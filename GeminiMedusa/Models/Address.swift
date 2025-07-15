//
//  Address.swift
//  BoltMedusaAuth
//
//  Created by Ricardo Bento on 28/06/2025.
//

import Foundation

struct Address: Codable, Identifiable, Equatable {
    let id: String
    let addressName: String?
    let isDefaultShipping: Bool
    let isDefaultBilling: Bool
    let customerId: String
    let company: String?
    let firstName: String?
    let lastName: String?
    let address1: String
    let address2: String?
    let city: String
    let countryCode: String
    let province: String?
    let postalCode: String
    let phone: String?
    let createdAt: String
    let updatedAt: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        addressName = try container.decodeIfPresent(String.self, forKey: .addressName)
        isDefaultShipping = try container.decode(Bool.self, forKey: .isDefaultShipping)
        isDefaultBilling = try container.decode(Bool.self, forKey: .isDefaultBilling)
        customerId = try container.decode(String.self, forKey: .customerId)
        company = try container.decodeIfPresent(String.self, forKey: .company)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        address1 = try container.decode(String.self, forKey: .address1)
        address2 = try container.decodeIfPresent(String.self, forKey: .address2)
        city = try container.decode(String.self, forKey: .city)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        province = try container.decodeIfPresent(String.self, forKey: .province)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)

        print("Address ID: \(id), isDefaultShipping: \(isDefaultShipping), isDefaultBilling: \(isDefaultBilling)")
    }
    
    var formattedAddress: String {
        var components: [String] = []
        if let firstName = firstName, let lastName = lastName {
            components.append("\(firstName) \(lastName)")
        }
        if let company = company, !company.isEmpty {
            components.append(company)
        }
        components.append(address1)
        if let address2 = address2, !address2.isEmpty {
            components.append(address2)
        }
        components.append("\(city), \(postalCode)")
        if let province = province, !province.isEmpty {
            components.append(province)
        }
        components.append(countryCode)
        if let phone = phone, !phone.isEmpty {
            components.append(phone)
        }
        return components.joined(separator: "\n")
    }
    
    enum CodingKeys: String, CodingKey {
        case id, company, city, phone
        case addressName = "address_name"
        case isDefaultShipping = "is_default_shipping"
        case isDefaultBilling = "is_default_billing"
        case customerId = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case address1 = "address_1"
        case address2 = "address_2"
        case countryCode = "country_code"
        case province
        case postalCode = "postal_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "address_1": address1,
            "city": city,
            "country_code": countryCode.lowercased(),
            "postal_code": postalCode
        ]
        
        if let firstName = firstName { dict["first_name"] = firstName }
        if let lastName = lastName { dict["last_name"] = lastName }
        if let address2 = address2 { dict["address_2"] = address2 }
        if let phone = phone { dict["phone"] = phone }
        if let company = company { dict["company"] = company }
        if let province = province { dict["province"] = province }
        
        return dict
    }
}

struct AddressRequest: Codable {
    let addressName: String?
    let isDefaultShipping: Bool?
    let isDefaultBilling: Bool?
    let company: String?
    let firstName: String?
    let lastName: String?
    let address1: String
    let address2: String?
    let city: String
    let countryCode: String
    let province: String?
    let postalCode: String
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case company, city, phone, province
        case addressName = "address_name"
        case isDefaultShipping = "is_default_shipping"
        case isDefaultBilling = "is_default_billing"
        case firstName = "first_name"
        case lastName = "last_name"
        case address1 = "address_1"
        case address2 = "address_2"
        case countryCode = "country_code"
        case postalCode = "postal_code"
    }
}

struct AddressResponse: Codable {
    let address: Address
}
