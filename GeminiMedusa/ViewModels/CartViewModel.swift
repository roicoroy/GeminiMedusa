import Foundation

class CartViewModel: ObservableObject {
    @Published var cartItems: [String: Int] = [:]
    
    // This will be populated by the CartService
    func updateCartItems(with items: [String: Int]) {
        self.cartItems = items
    }
}
