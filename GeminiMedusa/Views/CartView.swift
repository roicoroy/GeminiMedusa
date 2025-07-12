import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartService: CartService

    var body: some View {
        NavigationView {
            List {
                if cartService.cartItems.isEmpty {
                    Text("Your cart is empty.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(cartService.cartItems.keys.sorted(), id: \.self) { productId in
                        HStack {
                            Text("Product ID: \(productId)")
                            Spacer()
                            Text("Quantity: \(cartService.cartItems[productId] ?? 0)")
                            Button(action: {
                                cartService.removeProduct(productId: productId)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("Shopping Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
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

    private func removeItems(at offsets: IndexSet) {
        // This is a simplified removal. In a real app, you'd map product IDs to indices.
        // For now, we'll just clear the whole cart if any item is swiped.
        // A more robust solution would involve passing the actual product ID to removeProduct.
        for index in offsets {
            let productId = cartService.cartItems.keys.sorted()[index]
            cartService.removeProduct(productId: productId, quantity: cartService.cartItems[productId] ?? 0)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartService())
    }
}
