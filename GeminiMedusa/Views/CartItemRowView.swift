import SwiftUI

struct CartItemRowView: View {
    let item: CartLineItem
    let currencyCode: String?
    @EnvironmentObject var cartService: CartService

    var body: some View {
        HStack {
            Text(item.title ?? "Unknown Item")
            Spacer()
            Text("Quantity: \(item.quantity)")
            if let currencyCode = currencyCode {
                Text(formatPrice(item.unitPrice * Double(item.quantity), currencyCode: currencyCode))
            }
            Button(action: {
                cartService.removeLineItem(lineItemId: item.id)
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
        }
    }
}