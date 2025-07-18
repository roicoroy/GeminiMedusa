//
//  ProductWithPrice.swift
//  BoltMedusaAuth
//
//  Created by Ricardo Bento on 04/07/2025.
//

import Foundation

// MARK: - ProductWithPrice Models
struct ProductWithPrice: Codable, Identifiable, Hashable, Equatable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String?
    let handle: String?
    let isGiftcard: Bool
    let discountable: Bool?
    let thumbnail: String?
    let collectionId: String?
    let typeId: String?
    let weight: String?
    let length: Int?
    let height: Int?
    let width: Int?
    let hsCode: String?
    let originCountry: String?
    let midCode: String?
    let material: String?
    let createdAt: String
    let updatedAt: String
    let type: ProductWithPriceType?
    let collection: ProductWithPriceCollection?
    let options: [ProductWithPriceOption]?
    let tags: [ProductWithPriceTag]?
    let images: [ProductWithPriceImage]?
    let variants: [ProductWithPriceVariant]?

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, description, handle, thumbnail, type, collection, options, tags, images, variants, weight, length, height, width, material
        case isGiftcard = "is_giftcard"
        case discountable
        case collectionId = "collection_id"
        case typeId = "type_id"
        case hsCode = "hs_code"
        case originCountry = "origin_country"
        case midCode = "mid_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    static func == (lhs: ProductWithPrice, rhs: ProductWithPrice) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ProductWithPriceType: Codable, Identifiable {
    let id: String
    let value: String
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductWithPriceCollection: Codable, Identifiable {
    let id: String
    let title: String
    let handle: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, handle
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductWithPriceOption: Codable, Identifiable {
    let id: String
    let title: String
    let metadata: String?
    let productId: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let values: [ProductWithPriceOptionValue]?

    enum CodingKeys: String, CodingKey {
        case id, title, metadata, values
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductWithPriceOptionValue: Codable, Identifiable {
    let id: String
    let value: String
    let metadata: String?
    let optionId: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let option: ProductWithPriceOption? // Nested option

    enum CodingKeys: String, CodingKey {
        case id, value, metadata, option
        case optionId = "option_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductWithPriceTag: Codable, Identifiable {
    let id: String
    // Add other properties if available in the JSON for tags
}

struct ProductWithPriceImage: Codable, Identifiable {
    let id: String
    let url: String
    let metadata: String?
    let rank: Int?
    let productId: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, url, metadata, rank
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductWithPriceVariant: Codable, Identifiable, Hashable, Equatable {
    let id: String
    let title: String
    let sku: String?
    let barcode: String?
    let ean: String?
    let upc: String?
    let allowBackorder: Bool?
    let manageInventory: Bool?
    let hsCode: String?
    let originCountry: String?
    let midCode: String?
    let material: String?
    let weight: Int?
    let length: Int?
    let height: Int?
    let width: Int?
    let metadata: String?
    let variantRank: Int?
    let productId: String?
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    let options: [ProductWithPriceOptionValue]?
    let calculatedPrice: ProductWithPriceCalculatedPrice?

    enum CodingKeys: String, CodingKey {
        case id, title, sku, barcode, ean, upc, material, weight, length, height, width, metadata, options
        case allowBackorder = "allow_backorder"
        case manageInventory = "manage_inventory"
        case hsCode = "hs_code"
        case originCountry = "origin_country"
        case midCode = "mid_code"
        case variantRank = "variant_rank"
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case calculatedPrice = "calculated_price"
    }

    static func == (lhs: ProductWithPriceVariant, rhs: ProductWithPriceVariant) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ProductWithPriceCalculatedPrice: Codable, Identifiable {
    let id: String
    let isCalculatedPricePriceList: Bool
    let isCalculatedPriceTaxInclusive: Bool
    let calculatedAmount: Double
    let rawCalculatedAmount: ProductWithPriceRawAmount
    let isOriginalPricePriceList: Bool
    let isOriginalPriceTaxInclusive: Bool
    let originalAmount: Double
    let rawOriginalAmount: ProductWithPriceRawAmount
    let currencyCode: String
    let calculatedPrice: ProductWithPricePrice?
    let originalPrice: ProductWithPricePrice?

    enum CodingKeys: String, CodingKey {
        case id
        case isCalculatedPricePriceList = "is_calculated_price_price_list"
        case isCalculatedPriceTaxInclusive = "is_calculated_price_tax_inclusive"
        case calculatedAmount = "calculated_amount"
        case rawCalculatedAmount = "raw_calculated_amount"
        case isOriginalPricePriceList = "is_original_price_price_list"
        case isOriginalPriceTaxInclusive = "is_original_price_tax_inclusive"
        case originalAmount = "original_amount"
        case rawOriginalAmount = "raw_original_amount"
        case currencyCode = "currency_code"
        case calculatedPrice = "calculated_price"
        case originalPrice = "original_price"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        isCalculatedPricePriceList = try container.decode(Bool.self, forKey: .isCalculatedPricePriceList)
        isCalculatedPriceTaxInclusive = try container.decode(Bool.self, forKey: .isCalculatedPriceTaxInclusive)
        rawCalculatedAmount = try container.decode(ProductWithPriceRawAmount.self, forKey: .rawCalculatedAmount)
        isOriginalPricePriceList = try container.decode(Bool.self, forKey: .isOriginalPricePriceList)
        isOriginalPriceTaxInclusive = try container.decode(Bool.self, forKey: .isOriginalPriceTaxInclusive)
        rawOriginalAmount = try container.decode(ProductWithPriceRawAmount.self, forKey: .rawOriginalAmount)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        calculatedPrice = try container.decodeIfPresent(ProductWithPricePrice.self, forKey: .calculatedPrice)
        originalPrice = try container.decodeIfPresent(ProductWithPricePrice.self, forKey: .originalPrice)

        // Handle flexible decoding for calculatedAmount and originalAmount
        calculatedAmount = try Self.decodeFlexibleDouble(from: container, forKey: .calculatedAmount) ?? 0.0
        originalAmount = try Self.decodeFlexibleDouble(from: container, forKey: .originalAmount) ?? 0.0
    }

    private static func decodeFlexibleDouble(from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Double? {
        if let doubleValue = try? container.decode(Double.self, forKey: key) {
            return doubleValue
        } else if let intValue = try? container.decode(Int.self, forKey: key) {
            return Double(intValue)
        } else {
            return nil
        }
    }
}

struct ProductWithPriceRawAmount: Codable {
    let value: String
    let precision: Int
}

struct ProductWithPricePrice: Codable, Identifiable {
    let id: String
    let priceListId: String?
    let priceListType: String?
    let minQuantity: Int?
    let maxQuantity: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case priceListId = "price_list_id"
        case priceListType = "price_list_type"
        case minQuantity = "min_quantity"
        case maxQuantity = "max_quantity"
    }
}

// MARK: - API Response Models
struct ProductWithPriceResponse: Codable {
    let products: [ProductWithPrice]
    let count: Int
    let offset: Int
    let limit: Int
}