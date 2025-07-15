//
//  Customer.swift
//  BoltMedusaAuth
//
//  Created by Ricardo Bento on 28/06/2025.
//

import Foundation

struct Customer: Codable, Identifiable, Equatable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, email, addresses, phone
        case defaultBillingAddressId = "default_billing_address_id"
        case defaultShippingAddressId = "default_shipping_address_id"
        case companyName = "company_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        defaultBillingAddressId = try container.decodeIfPresent(String.self, forKey: .defaultBillingAddressId)
        defaultShippingAddressId = try container.decodeIfPresent(String.self, forKey: .defaultShippingAddressId)
        companyName = try container.decodeIfPresent(String.self, forKey: .companyName)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        addresses = try container.decodeIfPresent([Address].self, forKey: .addresses)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)
        
        print("Customer ID: \(id), defaultShippingAddressId: \(defaultShippingAddressId ?? "nil"), defaultBillingAddressId: \(defaultBillingAddressId ?? "nil")")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(defaultBillingAddressId, forKey: .defaultBillingAddressId)
        try container.encodeIfPresent(defaultShippingAddressId, forKey: .defaultShippingAddressId)
        try container.encodeIfPresent(companyName, forKey: .companyName)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(addresses, forKey: .addresses)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
    }
    
    var shippingAddresses: [Address] {
        if let defaultId = defaultShippingAddressId, let defaultAddress = addresses?.first(where: { $0.id == defaultId }) {
            var sortedAddresses = [defaultAddress]
            sortedAddresses.append(contentsOf: addresses?.filter { $0.id != defaultId } ?? [])
            return sortedAddresses
        } else {
            return addresses ?? []
        }
    }
    
    var billingAddresses: [Address] {
        if let defaultId = defaultBillingAddressId, let defaultAddress = addresses?.first(where: { $0.id == defaultId }) {
            var sortedAddresses = [defaultAddress]
            sortedAddresses.append(contentsOf: addresses?.filter { $0.id != defaultId } ?? [])
            return sortedAddresses
        } else {
            return addresses ?? []
        }
    }
}
