import SwiftUI

struct ProductVariantRowView: View {
    let variant: ProductWithPriceVariant
    let currencyCode: String

    var body: some View {
        Text("\(variant.title ?? "Unknown Variant") - \(formatPrice(variant.calculatedPrice?.calculatedAmount ?? 0, currencyCode: currencyCode))")
    }
}