import SwiftUI

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService

    var body: some View {
        NavigationView {
            List {
                if let items = cartService.currentCart?.items, !items.isEmpty {
                    ForEach(items) { item in
                        HStack {
                            Text(item.title ?? "Unknown Item")
                            Spacer()
                            Text("Quantity: \(item.quantity)")
                            if let currencyCode = regionService.selectedRegionCurrency {
                                Text(formatPrice(item.unitPrice, currencyCode: currencyCode))
                            }
                            Button(action: {
                                cartService.removeLineItem(lineItemId: item.id)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                } else {
                    Text("Your cart is empty.")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Shopping Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        cartService.clearCart()
                    }) {
                        Text("Clear Cart")
                    }
                }
            }
        }
    }

    
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartService())
    }
}
