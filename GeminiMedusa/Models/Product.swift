
//
//  Product.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import Foundation

// This is a placeholder struct to satisfy compilation requirements
// where 'Product' type is referenced but 'ProductWithPrice' is the primary model.
struct Product: Codable, Identifiable {
    let id: String
    let title: String
    // Add other minimal properties if absolutely necessary for compilation
    // For now, we'll keep it minimal.
}

// Placeholder API Response Models if they are still referenced
struct ProductsResponse: Codable {
    let products: [Product]
    let count: Int
    let offset: Int
    let limit: Int
}

struct ProductResponse: Codable {
    let product: Product
}
