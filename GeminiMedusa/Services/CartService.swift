import Foundation

class CartService: ObservableObject {
    @Published var cartItems: [String: Int] = [:] // [productId: quantity]

    func addProduct(productId: String, quantity: Int = 1) {
        cartItems[productId, default: 0] += quantity
        print("Added \(quantity) of product \(productId). Current cart: \(cartItems)")
    }

    func removeProduct(productId: String, quantity: Int = 1) {
        if let currentQuantity = cartItems[productId] {
            let newQuantity = currentQuantity - quantity
            if newQuantity <= 0 {
                cartItems[productId] = nil
            } else {
                cartItems[productId] = newQuantity
            }
            print("Removed \(quantity) of product \(productId). Current cart: \(cartItems)")
        }
    }

    func clearCart() {
        cartItems = [:]
        print("Cart cleared.")
    }
}
