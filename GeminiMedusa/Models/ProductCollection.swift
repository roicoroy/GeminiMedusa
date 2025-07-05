
//
//  ProductCollection.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import Foundation

struct ProductCollection: Codable, Identifiable {
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
