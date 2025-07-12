import Foundation


public struct CartLineItem: Codable, Identifiable {
    public let id: String
    public let thumbnail: String?
    public let variantId: String
    public let productId: String
    public let productTypeId: String?
    public let productTitle: String?
    public let productDescription: String?
    public let productSubtitle: String?
    public let productType: String?
    public let productCollection: String?
    public let productHandle: String?
    public let variantSku: String?
    public let variantBarcode: String?
    public let variantTitle: String?
    public let requiresShipping: Bool
    public let metadata: [String: AnyCodable]?
    public let createdAt: String?
    public let updatedAt: String?
    public let title: String
    public let quantity: Int
    public let unitPrice: Int
    public let compareAtUnitPrice: Int?
    public let isTaxInclusive: Bool
    public let taxLines: [TaxLine]?
    public let adjustments: [Adjustment]?
    public let product: CartProduct?

    enum CodingKeys: String, CodingKey {
        case id, thumbnail, title, quantity, metadata, product
        case variantId = "variant_id"
        case productId = "product_id"
        case productTypeId = "product_type_id"
        case productTitle = "product_title"
        case productDescription = "product_description"
        case productSubtitle = "product_subtitle"
        case productType = "product_type"
        case productCollection = "product_collection"
        case productHandle = "product_handle"
        case variantSku = "variant_sku"
        case variantBarcode = "variant_barcode"
        case variantTitle = "variant_title"
        case requiresShipping = "requires_shipping"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case unitPrice = "unit_price"
        case compareAtUnitPrice = "compare_at_unit_price"
        case isTaxInclusive = "is_tax_inclusive"
        case taxLines = "tax_lines"
        case adjustments
    }
    
    // Custom decoder to handle flexible numeric types and exact API response structure
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Required fields
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        variantId = try container.decode(String.self, forKey: .variantId)
        productId = try container.decode(String.self, forKey: .productId)
        quantity = try container.decode(Int.self, forKey: .quantity)
        requiresShipping = try container.decode(Bool.self, forKey: .requiresShipping)
        isTaxInclusive = try container.decode(Bool.self, forKey: .isTaxInclusive)

        // Handle flexible numeric types for price fields
        unitPrice = try decodeFlexibleInt(from: container, forKey: .unitPrice) ?? 0
        compareAtUnitPrice = try decodeFlexibleInt(from: container, forKey: .compareAtUnitPrice)

        // Optional fields
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        productTypeId = try container.decodeIfPresent(String.self, forKey: .productTypeId)
        productTitle = try container.decodeIfPresent(String.self, forKey: .productTitle)
        productDescription = try container.decodeIfPresent(String.self, forKey: .productDescription)
        productSubtitle = try container.decodeIfPresent(String.self, forKey: .productSubtitle)
        productType = try container.decodeIfPresent(String.self, forKey: .productType)
        productCollection = try container.decodeIfPresent(String.self, forKey: .productCollection)
        productHandle = try container.decodeIfPresent(String.self, forKey: .productHandle)
        variantSku = try container.decodeIfPresent(String.self, forKey: .variantSku)
        variantBarcode = try container.decodeIfPresent(String.self, forKey: .variantBarcode)
        variantTitle = try container.decodeIfPresent(String.self, forKey: .variantTitle)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        taxLines = try container.decodeIfPresent([TaxLine].self, forKey: .taxLines)
        adjustments = try container.decodeIfPresent([Adjustment].self, forKey: .adjustments)
        product = try container.decodeIfPresent(CartProduct.self, forKey: .product)

        metadata = try container.decodeIfPresent([String: AnyCodable].self, forKey: .metadata)
    }
}
