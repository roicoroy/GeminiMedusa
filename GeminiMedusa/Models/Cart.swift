import Foundation




// MARK: - Cart Models
public struct Cart: Codable, Identifiable {
    public let id: String
    public let currencyCode: String
    public let customerId: String?
    public let email: String?
    public let regionId: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let completedAt: String?
    public let total: Double
    public let subtotal: Double
    public let taxTotal: Double
    public let discountTotal: Double
    public let discountSubtotal: Double
    public let discountTaxTotal: Double
    public let originalTotal: Double
    public let originalTaxTotal: Double
    public let itemTotal: Double
    public let itemSubtotal: Double
    public let itemTaxTotal: Double
    public let originalItemTotal: Double
    public let originalItemSubtotal: Double
    public let originalItemTaxTotal: Double
    public let shippingTotal: Double
    public let shippingSubtotal: Double
    public let shippingTaxTotal: Double
    public let originalShippingTaxTotal: Double
    public let originalShippingSubtotal: Double
    public let originalShippingTotal: Double
    public let creditLineSubtotal: Double
    public let creditLineTaxTotal: Double
    public let creditLineTotal: Double
    public let metadata: [String: AnyCodable]?
    public let salesChannelId: String?
    public let items: [CartLineItem]?
    public let promotions: [CartPromotion]?
    public let region: CartRegion?
    
    public var shippingAddress: CartAddress?
    public var billingAddress: CartAddress?
    public var paymentCollection: PaymentCollection? // Added paymentCollection

    enum CodingKeys: String, CodingKey {
        case id, email, metadata, items, promotions, region
        case currencyCode = "currency_code"
        case customerId = "customer_id"
        case regionId = "region_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case completedAt = "completed_at"
        case total, subtotal
        case taxTotal = "tax_total"
        case discountTotal = "discount_total"
        case discountSubtotal = "discount_subtotal"
        case discountTaxTotal = "discount_tax_total"
        case originalTotal = "original_total"
        case originalTaxTotal = "original_tax_total"
        case itemTotal = "item_total"
        case itemSubtotal = "item_subtotal"
        case itemTaxTotal = "item_tax_total"
        case originalItemTotal = "original_item_total"
        case originalItemSubtotal = "original_item_subtotal"
        case originalItemTaxTotal = "original_item_tax_total"
        case shippingTotal = "shipping_total"
        case shippingSubtotal = "shipping_subtotal"
        case shippingTaxTotal = "shipping_tax_total"
        case originalShippingTaxTotal = "original_shipping_tax_total"
        case originalShippingSubtotal = "original_shipping_subtotal"
        case originalShippingTotal = "original_shipping_total"
        case creditLineSubtotal = "credit_line_subtotal"
        case creditLineTaxTotal = "credit_line_tax_total"
        case creditLineTotal = "credit_line_total"
        case salesChannelId = "sales_channel_id"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case paymentCollection = "payment_collection" // Added paymentCollection
    }

    // Custom decoder to handle flexible numeric types and exact API response structure
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Required fields
        id = try container.decode(String.self, forKey: .id)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)

        // Handle flexible numeric types for all price fields
        total = try decodeFlexibleDouble(from: container, forKey: .total) ?? 0.0
        subtotal = try decodeFlexibleDouble(from: container, forKey: .subtotal) ?? 0.0
        taxTotal = try decodeFlexibleDouble(from: container, forKey: .taxTotal) ?? 0.0
        discountTotal = try decodeFlexibleDouble(from: container, forKey: .discountTotal) ?? 0.0
        discountSubtotal = try decodeFlexibleDouble(from: container, forKey: .discountSubtotal) ?? 0.0
        discountTaxTotal = try decodeFlexibleDouble(from: container, forKey: .discountTaxTotal) ?? 0.0
        originalTotal = try decodeFlexibleDouble(from: container, forKey: .originalTotal) ?? 0.0
        originalTaxTotal = try decodeFlexibleDouble(from: container, forKey: .originalTaxTotal) ?? 0.0
        itemTotal = try decodeFlexibleDouble(from: container, forKey: .itemTotal) ?? 0.0
        itemSubtotal = try decodeFlexibleDouble(from: container, forKey: .itemSubtotal) ?? 0.0
        itemTaxTotal = try decodeFlexibleDouble(from: container, forKey: .itemTaxTotal) ?? 0.0
        originalItemTotal = try decodeFlexibleDouble(from: container, forKey: .originalItemTotal) ?? 0.0
        originalItemSubtotal = try decodeFlexibleDouble(from: container, forKey: .originalItemSubtotal) ?? 0.0
        originalItemTaxTotal = try decodeFlexibleDouble(from: container, forKey: .originalItemTaxTotal) ?? 0.0
        shippingTotal = try decodeFlexibleDouble(from: container, forKey: .shippingTotal) ?? 0.0
        shippingSubtotal = try decodeFlexibleDouble(from: container, forKey: .shippingSubtotal) ?? 0.0
        shippingTaxTotal = try decodeFlexibleDouble(from: container, forKey: .shippingTaxTotal) ?? 0.0
        originalShippingTaxTotal = try decodeFlexibleDouble(from: container, forKey: .originalShippingTaxTotal) ?? 0.0
        originalShippingSubtotal = try decodeFlexibleDouble(from: container, forKey: .originalShippingSubtotal) ?? 0.0
        originalShippingTotal = try decodeFlexibleDouble(from: container, forKey: .originalShippingTotal) ?? 0.0
        creditLineSubtotal = try decodeFlexibleDouble(from: container, forKey: .creditLineSubtotal) ?? 0.0
        creditLineTaxTotal = try decodeFlexibleDouble(from: container, forKey: .creditLineTaxTotal) ?? 0.0
        creditLineTotal = try decodeFlexibleDouble(from: container, forKey: .creditLineTotal) ?? 0.0
        
        // Optional fields
        customerId = try container.decodeIfPresent(String.self, forKey: .customerId)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        regionId = try container.decodeIfPresent(String.self, forKey: .regionId)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        completedAt = try container.decodeIfPresent(String.self, forKey: .completedAt)
        salesChannelId = try container.decodeIfPresent(String.self, forKey: .salesChannelId)
        
        // Arrays and objects
        items = try container.decodeIfPresent([CartLineItem].self, forKey: .items)
        promotions = try container.decodeIfPresent([CartPromotion].self, forKey: .promotions)
        region = try container.decodeIfPresent(CartRegion.self, forKey: .region)
        shippingAddress = try container.decodeIfPresent(CartAddress.self, forKey: .shippingAddress)
        billingAddress = try container.decodeIfPresent(CartAddress.self, forKey: .billingAddress)
        paymentCollection = try container.decodeIfPresent(PaymentCollection.self, forKey: .paymentCollection) // Decoded paymentCollection
        
        metadata = try container.decodeIfPresent([String: AnyCodable].self, forKey: .metadata)
    }
    
    
    
    
    // Custom encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(currencyCode, forKey: .currencyCode)
        try container.encode(total, forKey: .total)
        try container.encode(subtotal, forKey: .subtotal)
        try container.encode(taxTotal, forKey: .taxTotal)
        try container.encode(discountTotal, forKey: .discountTotal)
        try container.encode(discountSubtotal, forKey: .discountSubtotal)
        try container.encode(discountTaxTotal, forKey: .discountTaxTotal)
        try container.encode(originalTotal, forKey: .originalTotal)
        try container.encode(originalTaxTotal, forKey: .originalTaxTotal)
        try container.encode(itemTotal, forKey: .itemTotal)
        try container.encode(itemSubtotal, forKey: .itemSubtotal)
        try container.encode(itemTaxTotal, forKey: .itemTaxTotal)
        try container.encode(originalItemTotal, forKey: .originalItemTotal)
        try container.encode(originalItemSubtotal, forKey: .originalItemSubtotal)
        try container.encode(originalItemTaxTotal, forKey: .originalItemTaxTotal)
        try container.encode(shippingTotal, forKey: .shippingTotal)
        try container.encode(shippingSubtotal, forKey: .shippingSubtotal)
        try container.encode(shippingTaxTotal, forKey: .shippingTaxTotal)
        try container.encode(originalShippingTaxTotal, forKey: .originalShippingTaxTotal)
        try container.encode(originalShippingSubtotal, forKey: .originalShippingSubtotal)
        try container.encode(originalShippingTotal, forKey: .originalShippingTotal)
        
        try container.encodeIfPresent(customerId, forKey: .customerId)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(regionId, forKey: .regionId)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(completedAt, forKey: .completedAt)
        try container.encodeIfPresent(salesChannelId, forKey: .salesChannelId)
        try container.encodeIfPresent(items, forKey: .items)
        try container.encodeIfPresent(promotions, forKey: .promotions)
        try container.encodeIfPresent(region, forKey: .region)
        try container.encodeIfPresent(shippingAddress, forKey: .shippingAddress)
        try container.encodeIfPresent(billingAddress, forKey: .billingAddress)
        try container.encodeIfPresent(paymentCollection, forKey: .paymentCollection) // Encoded paymentCollection
        
        // Skip metadata encoding for simplicity
    }
}



// MARK: - Cart Address Model
public struct CartAddress: Codable, Identifiable, Equatable {
    public var id: String
    public var firstName: String
    public var lastName: String
    public var company: String
    public var address1: String
    public var address2: String
    public var city: String
    public var countryCode: String
    public var province: String
    public var postalCode: String
    public var phone: String
    public var metadata: [String: AnyCodable]?

    public static func == (lhs: CartAddress, rhs: CartAddress) -> Bool {
        return lhs.id == rhs.id &&
               lhs.firstName == rhs.firstName &&
               lhs.lastName == rhs.lastName &&
               lhs.company == rhs.company &&
               lhs.address1 == rhs.address1 &&
               lhs.address2 == rhs.address2 &&
               lhs.city == rhs.city &&
               lhs.countryCode == rhs.countryCode &&
               lhs.province == rhs.province &&
               lhs.postalCode == rhs.postalCode &&
               lhs.phone == rhs.phone
    }

    public init(id: String = UUID().uuidString, firstName: String = "", lastName: String = "", company: String = "", address1: String = "", address2: String = "", city: String = "", countryCode: String = "", province: String = "", postalCode: String = "", phone: String = "", metadata: [String: AnyCodable]? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.countryCode = countryCode
        self.province = province
        self.postalCode = postalCode
        self.phone = phone
        self.metadata = metadata
    }

    enum CodingKeys: String, CodingKey {
        case id, company, city, phone, metadata
        case firstName = "first_name"
        case lastName = "last_name"
        case address1 = "address_1"
        case address2 = "address_2"
        case countryCode = "country_code"
        case province
        case postalCode = "postal_code"
    }
    
    // Custom decoder to handle flexible metadata
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        company = try container.decode(String.self, forKey: .company)
        address1 = try container.decode(String.self, forKey: .address1)
        address2 = try container.decode(String.self, forKey: .address2)
        city = try container.decode(String.self, forKey: .city)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        province = try container.decode(String.self, forKey: .province)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        phone = try container.decode(String.self, forKey: .phone)
        metadata = try container.decodeIfPresent([String: AnyCodable].self, forKey: .metadata)
    }
    
    // Custom encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(company, forKey: .company)
        try container.encodeIfPresent(address1, forKey: .address1)
        try container.encodeIfPresent(address2, forKey: .address2)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(province, forKey: .province)
        try container.encodeIfPresent(postalCode, forKey: .postalCode)
        try container.encodeIfPresent(phone, forKey: .phone)
        
        // Skip metadata encoding for simplicity
    }
}








public struct Adjustment: Codable {
    // Add adjustment properties as needed
}

public struct CartProduct: Codable, Identifiable {
    public let id: String
    public let collectionId: String?
    public let typeId: String?
    public let categories: [ProductCategory]?
    public let tags: [ProductTag]?
    
    enum CodingKeys: String, CodingKey {
        case id, categories, tags
        case collectionId = "collection_id"
        case typeId = "type_id"
    }
}



public struct ProductTag: Codable, Identifiable {
    public let id: String
}

// MARK: - API Request/Response Models
public struct CartResponse: Codable {
    public let cart: Cart
}

public struct CreateCartRequest: Codable {
    public let regionId: String
    
    enum CodingKeys: String, CodingKey {
        case regionId = "region_id"
    }
}

public struct AddLineItemRequest: Codable {
    public let variantId: String
    public let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case variantId = "variant_id"
        case quantity
    }
}

public struct UpdateLineItemRequest: Codable {
    public let quantity: Int
}

// MARK: - Helper Extensions
extension Cart {
    public func formattedTotal(currencyCode: String? = nil) -> String {
        return formatPrice(Double(total) / 100.0, currencyCode: currencyCode ?? self.currencyCode)
    }
    
    public func formattedSubtotal(currencyCode: String? = nil) -> String {
        return formatPrice(Double(subtotal) / 100.0, currencyCode: currencyCode ?? self.currencyCode)
    }
    
    public func formattedTaxTotal(currencyCode: String? = nil) -> String {
        return formatPrice(Double(taxTotal) / 100.0, currencyCode: currencyCode ?? self.currencyCode)
    }
    
    public func formattedShippingTotal(currencyCode: String? = nil) -> String {
        return formatPrice(Double(shippingTotal) / 100.0, currencyCode: currencyCode ?? self.currencyCode)
    }
    
    public func formattedDiscountTotal(currencyCode: String? = nil) -> String {
        return formatPrice(Double(discountTotal) / 100.0, currencyCode: currencyCode ?? self.currencyCode)
    }
    
    public var formattedTotal: String {
        return formatPrice(Double(total) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedSubtotal: String {
        return formatPrice(Double(subtotal) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedTaxTotal: String {
        return formatPrice(Double(taxTotal) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedShippingTotal: String {
        return formatPrice(Double(shippingTotal) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedDiscountTotal: String {
        return formatPrice(Double(discountTotal) / 100.0, currencyCode: currencyCode)
    }
    
    public var itemCount: Int {
        return items?.reduce(0) { $0 + $1.quantity } ?? 0
    }
    
    public var isEmpty: Bool {
        return items?.isEmpty ?? true
    }
    
    public var isAssociatedWithCustomer: Bool {
        return customerId != nil
    }
    
    public var customerStatus: String {
        if let customerId = customerId {
            return "Customer: \(customerId)"
        } else {
            return "Anonymous Cart"
        }
    }
    
    public var hasShippingAddress: Bool {
        return shippingAddress != nil
    }
    
    public var hasBillingAddress: Bool {
        return billingAddress != nil
    }
    
    public var isReadyForCheckout: Bool {
        return !isEmpty && hasShippingAddress && hasBillingAddress
    }
}

extension CartLineItem {
    public func formattedUnitPrice(currencyCode: String) -> String {
        return formatPrice(unitPrice, currencyCode: currencyCode)
    }
    
    public func formattedTotal(currencyCode: String) -> String {
        // Calculate total since it's not provided in the API response
        let calculatedTotal = unitPrice * Double(quantity)
        return formatPrice(calculatedTotal, currencyCode: currencyCode)
    }
    
    public func formattedSubtotal(currencyCode: String) -> String {
        // Calculate subtotal since it's not provided in the API response
        let calculatedSubtotal = unitPrice * Double(quantity)
        return formatPrice(calculatedSubtotal, currencyCode: currencyCode)
    }
    
    public var formattedUnitPrice: String {
        return formatPrice(unitPrice, currencyCode: "USD")
    }
    
    public var formattedTotal: String {
        // Calculate total since it's not provided in the API response
        let calculatedTotal = unitPrice * Double(quantity)
        return formatPrice(calculatedTotal, currencyCode: "USD")
    }
    
    public var formattedSubtotal: String {
        // Calculate subtotal since it's not provided in the API response
        let calculatedSubtotal = unitPrice * Double(quantity)
        return formatPrice(calculatedSubtotal, currencyCode: "USD")
    }
    
    public var calculatedTotal: Double {
        // Calculate total since it's not provided in the API response
        return unitPrice * Double(quantity)
    }
    
    public var calculatedSubtotal: Double {
        // Calculate subtotal since it's not provided in the API response
        return unitPrice * Double(quantity)
    }
    
    public var displayImage: String? {
        return thumbnail
    }
    
    public var displayTitle: String {
        return productTitle ?? title
    }
    
    public var displaySubtitle: String? {
        if let variantTitle = variantTitle, variantTitle != title {
            return variantTitle
        }
        return productSubtitle
    }
}

extension CartAddress {
    public var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    public var fullAddress: String {
        var components: [String] = []
        
        if !address1.isEmpty {
            components.append(address1)
        }
        
        if !address2.isEmpty {
            components.append(address2)
        }
        
        let provinceString = province
        if !city.isEmpty && !postalCode.isEmpty {
            components.append("\(city), \(provinceString) \(postalCode)")
        }
        
        if !countryCode.isEmpty {
            components.append(countryCode.uppercased())
        }
        
        return components.joined(separator: "\n")
    }
    
    public var singleLineAddress: String {
        var components: [String] = []
        
        if !address1.isEmpty {
            components.append(address1)
        }
        
        if !address2.isEmpty {
            components.append(address2)
        }
        
        let provinceString = province
        if !city.isEmpty && !postalCode.isEmpty && !countryCode.isEmpty {
            components.append("\(city), \(provinceString) \(postalCode), \(countryCode.uppercased())")
        }
        
        return components.joined(separator: ", ")
    }

}
