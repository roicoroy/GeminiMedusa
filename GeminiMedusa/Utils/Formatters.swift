import Foundation

public func formatPrice(_ amount: Int, currencyCode: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode
    let amountInMajorUnits = Double(amount) / 100.0
    return formatter.string(from: NSNumber(value: amountInMajorUnits)) ?? ""
}
