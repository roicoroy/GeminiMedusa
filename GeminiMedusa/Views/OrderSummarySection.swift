import SwiftUI

struct OrderSummarySection: View {
    let cart: Cart
    let currencyCode: String?

    var body: some View {
        Section(header: Text("Cart Summary")) {
            HStack {
                Text("Subtotal:")
                Spacer()
                Text(cart.formattedSubtotal(currencyCode: currencyCode))
            }
            HStack {
                Text("Shipping:")
                Spacer()
                Text(cart.formattedShippingTotal(currencyCode: currencyCode))
            }
            HStack {
                Text("Tax:")
                Spacer()
                Text(cart.formattedTaxTotal(currencyCode: currencyCode))
            }
            HStack {
                Text("Total:")
                Spacer()
                Text(cart.formattedTotal(currencyCode: currencyCode))
                    .font(.headline)
            }
        }
    }
}