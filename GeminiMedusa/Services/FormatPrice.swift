//
//  FormatPrice.swift
//  BoltMedusaAuth
//
//  Created by Ricardo Bento on 01/07/2025.
//

import Foundation

// MARK: - Currency Formatting

public struct PriceFormatter {
    public static func formatPrice(_ amount: Int, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode.uppercased()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        // Convert from cents to main currency unit (divide by 100)
        let decimalAmount = Double(amount)
        return formatter.string(from: NSNumber(value: decimalAmount)) ?? "\(currencyCode.uppercased()) 0.00"
    }
}

// MARK: - Price Formatting Extensions

extension Int {
    func formatAsCurrency(currencyCode: String) -> String {
        return PriceFormatter.formatPrice(self, currencyCode: currencyCode)
    }
    
    func formatAsCurrency(currencyCode: String?) -> String {
        return PriceFormatter.formatPrice(self, currencyCode: currencyCode ?? "USD")
    }
}


