import SwiftUI

struct CartItemRowView: View {
    let item: CartLineItem
    let currencyCode: String?
    @EnvironmentObject var cartService: CartService

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.displayTitle)
                    .font(.headline)
                if let subtitle = item.displaySubtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text("Quantity: \(item.quantity)")
            }
            Spacer()
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