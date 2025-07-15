
//
//  Order.swift
//  BoltMedusaAuth
//
//  Created by Ricardo Bento on 02/07/2025.
//

import Foundation

public struct OrderResponse: Codable {
    public let order: Order

    enum CodingKeys: String, CodingKey {
        case order
    }
}

// MARK: - Top Level Order Response

public struct OrdersResponse: Codable {
    public let limit: Int
    public let offset: Int
    public let count: Int
    public let orders: [Order]
}

// MARK: - Order Model

public struct Order: Codable, Identifiable {
    public let id: String
    public let regionId: String?
    public let customerId: String?
    public let salesChannelId: String?
    public let email: String?
    public let currencyCode: String
    public let items: [OrderLineItem]?
    public let shippingMethods: [OrderShippingMethod]?
    public let paymentStatus: String?
    public let fulfillmentStatus: String?
    public let summary: OrderSummary?
    public let createdAt: String?
    public let updatedAt: String?
    public let originalItemTotal: Double?
    public let originalItemSubtotal: Double?
    public let originalItemTaxTotal: Double?
    public let itemTotal: Double?
    public let itemSubtotal: Double?
    public let itemTaxTotal: Double?
    public let originalTotal: Double?
    public let originalSubtotal: Double?
    public let originalTaxTotal: Double?
    public let total: Double?
    public let subtotal: Double?
    public let taxTotal: Double?
    public let discountTotal: Double?
    public let discountTaxTotal: Double?
    public let giftCardTotal: Double?
    public let giftCardTaxTotal: Double?
    public let shippingTotal: Double?
    public let shippingSubtotal: Double?
    public let shippingTaxTotal: Double?
    public let originalShippingTotal: Double?
    public let originalShippingSubtotal: Double?
    public let originalShippingTaxTotal: Double?
    public let status: String?
    public let creditLineTotal: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case regionId = "region_id"
        case customerId = "customer_id"
        case salesChannelId = "sales_channel_id"
        case email
        case currencyCode = "currency_code"
        case items
        case shippingMethods = "shipping_methods"
        case paymentStatus = "payment_status"
        case fulfillmentStatus = "fulfillment_status"
        case summary
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case originalItemTotal = "original_item_total"
        case originalItemSubtotal = "original_item_subtotal"
        case originalItemTaxTotal = "original_item_tax_total"
        case itemTotal = "item_total"
        case itemSubtotal = "item_subtotal"
        case itemTaxTotal = "item_tax_total"
        case originalTotal = "original_total"
        case originalSubtotal = "original_subtotal"
        case originalTaxTotal = "original_tax_total"
        case total
        case subtotal
        case taxTotal = "tax_total"
        case discountTotal = "discount_total"
        case discountTaxTotal = "discount_tax_total"
        case giftCardTotal = "gift_card_total"
        case giftCardTaxTotal = "gift_card_tax_total"
        case shippingTotal = "shipping_total"
        case shippingSubtotal = "shipping_subtotal"
        case shippingTaxTotal = "shipping_tax_total"
        case originalShippingTotal = "original_shipping_total"
        case originalShippingSubtotal = "original_shipping_subtotal"
        case originalShippingTaxTotal = "original_shipping_tax_total"
        case status
        case creditLineTotal = "credit_line_total"
    }
    
    // Helper for formatted total
    public var formattedTotal: String {
        formatPrice(Double(total ?? 0) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedSubtotal: String {
        formatPrice(Double(subtotal ?? 0) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedShippingTotal: String {
        formatPrice(Double(shippingTotal ?? 0) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedTaxTotal: String {
        formatPrice(Double(taxTotal ?? 0) / 100.0, currencyCode: currencyCode)
    }
    
    public var formattedDiscountTotal: String {
        formatPrice(Double(discountTotal ?? 0) / 100.0, currencyCode: currencyCode)
    }
    
    public var displayStatus: String {
        status?.replacingOccurrences(of: "_", with: " ").capitalized ?? "N/A"
    }
    
    public var displayPaymentStatus: String {
        paymentStatus?.replacingOccurrences(of: "_", with: " ").capitalized ?? "N/A"
    }
    
    public var displayFulfillmentStatus: String {
        fulfillmentStatus?.replacingOccurrences(of: "_", with: " ").capitalized ?? "N/A"
    }
}

// MARK: - OrderLineItem Model

public struct OrderLineItem: Codable, Identifiable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let thumbnail: String?
    public let variantId: String?
    public let productId: String?
    public let productTitle: String?
    public let productDescription: String?
    public let productSubtitle: String?
    public let productType: String?
    public let productCollection: String?
    public let productHandle: String?
    public let variantSku: String?
    public let variantBarcode: String?
    public let variantTitle: String?
    public let variantOptionValues: [String: String]?
    public let requiresShipping: Bool
    public let isDiscountable: Bool
    public let isTaxInclusive: Bool
    public let unitPrice: Double
    public let quantity: Int
    public let detail: OrderLineItemDetail?
    public let createdAt: String?
    public let updatedAt: String?
    public let metadata: [String: AnyCodable]?
    public let originalTotal: Double?
    public let originalSubtotal: Double?
    public let originalTaxTotal: Double?
    public let itemTotal: Double?
    public let itemSubtotal: Double?
    public let itemTaxTotal: Double?
    public let total: Double?
    public let subtotal: Double?
    public let taxTotal: Double?
    public let discountTotal: Double?
    public let discountTaxTotal: Double?
    public let refundableTotal: Double?
    public let refundableTotalPerUnit: Double?
    public let productTypeId: String?

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, thumbnail
        case variantId = "variant_id"
        case productId = "product_id"
        case productTitle = "product_title"
        case productDescription = "product_description"
        case productSubtitle = "product_subtitle"
        case productType = "product_type"
        case productCollection = "product_collection"
        case productHandle = "product_handle"
        case variantSku = "variant_sku"
        case variantBarcode = "variant_barcode"
        case variantTitle = "variant_title"
        case variantOptionValues = "variant_option_values"
        case requiresShipping = "requires_shipping"
        case isDiscountable = "is_discountable"
        case isTaxInclusive = "is_tax_inclusive"
        case unitPrice = "unit_price"
        case quantity, detail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case metadata
        case originalTotal = "original_total"
        case originalSubtotal = "original_subtotal"
        case originalTaxTotal = "original_tax_total"
        case itemTotal = "item_total"
        case itemSubtotal = "item_subtotal"
        case itemTaxTotal = "item_tax_total"
        case total, subtotal
        case taxTotal = "tax_total"
        case discountTotal = "discount_total"
        case discountTaxTotal = "discount_tax_total"
        case refundableTotal = "refundable_total"
        case refundableTotalPerUnit = "refundable_total_per_per_unit"
        case productTypeId = "product_type_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        variantId = try container.decodeIfPresent(String.self, forKey: .variantId)
        productId = try container.decodeIfPresent(String.self, forKey: .productId)
        productTitle = try container.decodeIfPresent(String.self, forKey: .productTitle)
        productDescription = try container.decodeIfPresent(String.self, forKey: .productDescription)
        productSubtitle = try container.decodeIfPresent(String.self, forKey: .productSubtitle)
        productType = try container.decodeIfPresent(String.self, forKey: .productType)
        productCollection = try container.decodeIfPresent(String.self, forKey: .productCollection)
        productHandle = try container.decodeIfPresent(String.self, forKey: .productHandle)
        variantSku = try container.decodeIfPresent(String.self, forKey: .variantSku)
        variantBarcode = try container.decodeIfPresent(String.self, forKey: .variantBarcode)
        variantTitle = try container.decodeIfPresent(String.self, forKey: .variantTitle)
        variantOptionValues = try container.decodeIfPresent([String: String].self, forKey: .variantOptionValues)
        requiresShipping = try container.decode(Bool.self, forKey: .requiresShipping)
        isDiscountable = try container.decode(Bool.self, forKey: .isDiscountable)
        isTaxInclusive = try container.decode(Bool.self, forKey: .isTaxInclusive)
        unitPrice = try decodeFlexibleDouble(from: container, forKey: .unitPrice) ?? 0.0
        quantity = try container.decode(Int.self, forKey: .quantity)
        detail = try container.decodeIfPresent(OrderLineItemDetail.self, forKey: .detail)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        metadata = try container.decodeIfPresent([String: AnyCodable].self, forKey: .metadata)
        originalTotal = try decodeFlexibleDouble(from: container, forKey: .originalTotal)
        originalSubtotal = try decodeFlexibleDouble(from: container, forKey: .originalSubtotal)
        originalTaxTotal = try decodeFlexibleDouble(from: container, forKey: .originalTaxTotal)
        itemTotal = try decodeFlexibleDouble(from: container, forKey: .itemTotal)
        itemSubtotal = try decodeFlexibleDouble(from: container, forKey: .itemSubtotal)
        itemTaxTotal = try decodeFlexibleDouble(from: container, forKey: .itemTaxTotal)
        total = try decodeFlexibleDouble(from: container, forKey: .total)
        subtotal = try decodeFlexibleDouble(from: container, forKey: .subtotal)
        taxTotal = try decodeFlexibleDouble(from: container, forKey: .taxTotal)
        discountTotal = try decodeFlexibleDouble(from: container, forKey: .discountTotal)
        discountTaxTotal = try decodeFlexibleDouble(from: container, forKey: .discountTaxTotal)
        refundableTotal = try decodeFlexibleDouble(from: container, forKey: .refundableTotal)
        refundableTotalPerUnit = try decodeFlexibleDouble(from: container, forKey: .refundableTotalPerUnit)
        productTypeId = try container.decodeIfPresent(String.self, forKey: .productTypeId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(subtitle, forKey: .subtitle)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try container.encodeIfPresent(variantId, forKey: .variantId)
        try container.encodeIfPresent(productId, forKey: .productId)
        try container.encodeIfPresent(productTitle, forKey: .productTitle)
        try container.encodeIfPresent(productDescription, forKey: .productDescription)
        try container.encodeIfPresent(productSubtitle, forKey: .productSubtitle)
        try container.encodeIfPresent(productType, forKey: .productType)
        try container.encodeIfPresent(productCollection, forKey: .productCollection)
        try container.encodeIfPresent(productHandle, forKey: .productHandle)
        try container.encodeIfPresent(variantSku, forKey: .variantSku)
        try container.encodeIfPresent(variantBarcode, forKey: .variantBarcode)
        try container.encodeIfPresent(variantTitle, forKey: .variantTitle)
        try container.encodeIfPresent(variantOptionValues, forKey: .variantOptionValues)
        try container.encode(requiresShipping, forKey: .requiresShipping)
        try container.encode(isDiscountable, forKey: .isDiscountable)
        try container.encode(isTaxInclusive, forKey: .isTaxInclusive)
        try container.encode(unitPrice, forKey: .unitPrice)
        try container.encode(quantity, forKey: .quantity)
        try container.encodeIfPresent(detail, forKey: .detail)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(originalTotal, forKey: .originalTotal)
        try container.encodeIfPresent(originalSubtotal, forKey: .originalSubtotal)
        try container.encodeIfPresent(originalTaxTotal, forKey: .originalTaxTotal)
        try container.encodeIfPresent(itemTotal, forKey: .itemTotal)
        try container.encodeIfPresent(itemSubtotal, forKey: .itemSubtotal)
        try container.encodeIfPresent(itemTaxTotal, forKey: .itemTaxTotal)
        try container.encodeIfPresent(total, forKey: .total)
        try container.encodeIfPresent(subtotal, forKey: .subtotal)
        try container.encodeIfPresent(taxTotal, forKey: .taxTotal)
        try container.encodeIfPresent(discountTotal, forKey: .discountTotal)
        try container.encodeIfPresent(discountTaxTotal, forKey: .discountTaxTotal)
        try container.encodeIfPresent(refundableTotal, forKey: .refundableTotal)
        try container.encodeIfPresent(refundableTotalPerUnit, forKey: .refundableTotalPerUnit)
        try container.encodeIfPresent(productTypeId, forKey: .productTypeId)
    }
    
    public var displayTitle: String {
        title
    }
    
    public var displayImage: String? {
        thumbnail
    }
    
    public func formattedUnitPrice(currencyCode: String) -> String {
        formatPrice(unitPrice, currencyCode: currencyCode)
    }
    
    public func formattedTotal(currencyCode: String) -> String {
        formatPrice(Int(total ?? 0), currencyCode: currencyCode)
    }
}

// MARK: - OrderLineItemDetail Model

public struct OrderLineItemDetail: Codable, Identifiable {
    public let id: String
    public let itemId: String
    public let quantity: Int
    public let fulfilledQuantity: Int?
    public let deliveredQuantity: Int?
    public let shippedQuantity: Int?
    public let returnRequestedQuantity: Int?
    public let returnReceivedQuantity: Int?
    public let returnDismissedQuantity: Int?
    public let writtenOffQuantity: Int?
    public let metadata: [String: AnyCodable]?
    public let createdAt: String?
    public let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case itemId = "item_id"
        case quantity
        case fulfilledQuantity = "fulfilled_quantity"
        case deliveredQuantity = "delivered_quantity"
        case shippedQuantity = "shipped_quantity"
        case returnRequestedQuantity = "return_requested_quantity"
        case returnReceivedQuantity = "return_received_quantity"
        case returnDismissedQuantity = "return_dismissed_quantity"
        case writtenOffQuantity = "written_off_quantity"
        case metadata
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - OrderShippingMethod Model

public struct OrderShippingMethod: Codable, Identifiable {
    public let id: String
    public let orderId: String?
    public let name: String
    public let amount: Double
    public let isTaxInclusive: Bool
    public let shippingOptionId: String?
    public let data: [String: AnyCodable]?
    public let metadata: [String: AnyCodable]?
    public let originalTotal: Double?
    public let originalSubtotal: Double?
    public let originalTaxTotal: Double?
    public let total: Double?
    public let subtotal: Double?
    public let taxTotal: Double?
    public let discountTotal: Double?
    public let discountTaxTotal: Double?
    public let createdAt: String?
    public let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderId = "order_id"
        case name, amount
        case isTaxInclusive = "is_tax_inclusive"
        case shippingOptionId = "shipping_option_id"
        case data, metadata
        case originalTotal = "original_total"
        case originalSubtotal = "original_subtotal"
        case originalTaxTotal = "original_tax_total"
        case total, subtotal
        case taxTotal = "tax_total"
        case discountTotal = "discount_total"
        case discountTaxTotal = "discount_tax_total"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    public var formattedAmount: String {
        // Assuming currency code is available from the parent Order
        // For simplicity, we'll use a placeholder or require it from context
        formatPrice(amount / 100.0, currencyCode: "USD") // Placeholder, ideally from Order
    }
}

// MARK: - OrderSummary Model

public struct OrderSummary: Codable {
    public let paidTotal: Double?
    public let refundedTotal: Double?
    public let pendingDifference: Double?
    public let currentOrderTotal: Double?
    public let originalOrderTotal: Double?
    public let transactionTotal: Double?
    public let accountingTotal: Double?

    enum CodingKeys: String, CodingKey {
        case paidTotal = "paid_total"
        case refundedTotal = "refunded_total"
        case pendingDifference = "pending_difference"
        case currentOrderTotal = "current_order_total"
        case originalOrderTotal = "original_order_total"
        case transactionTotal = "transaction_total"
        case accountingTotal = "accounting_total"
    }
}
