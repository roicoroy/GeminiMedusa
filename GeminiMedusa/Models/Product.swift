
//
//  Product.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import Foundation

// This is a placeholder struct to satisfy compilation requirements
// where 'Product' type is referenced but 'ProductWithPrice' is the primary model.
struct Product: Codable, Identifiable, Equatable {
    let id: String
    let title: String?
    let subtitle: String?
    let description: String?
    let handle: String?
    let isGiftcard: Bool?
    let discountable: Bool?
    let thumbnail: String?
    let collectionId: String?
    let typeId: String?
    let weight: Int?
    let length: Int?
    let height: Int?
    let width: Int?
    let hsCode: String?
    let originCountry: String?
    let midCode: String?
    let material: String?
    let createdAt: String?
    let updatedAt: String?
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

    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}

// Placeholder API Response Models if they are still referenced
struct ProductsResponse: Codable {
    let products: [Product]
    let count: Int
    let offset: Int
    let limit: Int
}


