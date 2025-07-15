
//
//  FlexibleDecoder.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import Foundation

/// Decodes an integer value from a decoder, handling cases where the value might be a String or an Int.
/// - Parameters:
///   - container: The KeyedDecodingContainer to decode from.
///   - key: The CodingKey for the value to decode.
/// - Returns: An optional Int value.
func decodeFlexibleInt<Key: CodingKey>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> Int? {
    if let intValue = try? container.decode(Int.self, forKey: key) {
        return intValue
    }
    if let stringValue = try? container.decode(String.self, forKey: key), let intValue = Int(stringValue) {
        return intValue
    }
    return nil
}

/// Decodes a double value from a decoder, handling cases where the value might be a String, Int, or Double.
/// - Parameters:
///   - container: The KeyedDecodingContainer to decode from.
///   - key: The CodingKey for the value to decode.
/// - Returns: An optional Double value.
func decodeFlexibleDouble<Key: CodingKey>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> Double? {
    if let doubleValue = try? container.decode(Double.self, forKey: key) {
        return doubleValue
    }
    if let intValue = try? container.decode(Int.self, forKey: key) {
        return Double(intValue)
    }
    if let stringValue = try? container.decode(String.self, forKey: key), let doubleValue = Double(stringValue) {
        return doubleValue
    }
    return nil
}
