import Foundation
import Combine

class CheckoutViewModel: ObservableObject {
    @Published var shippingAddress: CartAddress
    @Published var billingAddress: CartAddress
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let cartService: CartService
    private var cancellables = Set<AnyCancellable>()

    init(cartService: CartService = CartService()) {
        self.cartService = cartService
        // Initialize with existing addresses from cart if available, otherwise create empty ones
        _shippingAddress = Published(initialValue: cartService.currentCart?.shippingAddress ?? CartAddress())
        _billingAddress = Published(initialValue: cartService.currentCart?.billingAddress ?? CartAddress())
    }

    func updateCartAddresses() {
        guard let cartId = cartService.currentCart?.id else {
            errorMessage = "No active cart found."
            return
        }

        isLoading = true
        errorMessage = nil

        // In a real app, you'd make API calls here to update the cart with addresses.
        // For now, we'll simulate success and update the local cart object.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            if var currentCart = self.cartService.currentCart {
                currentCart.shippingAddress = self.shippingAddress
                currentCart.billingAddress = self.billingAddress
                self.cartService.currentCart = currentCart
                self.isLoading = false
                self.errorMessage = nil
            } else {
                self.errorMessage = "Failed to update cart: Cart not found."
                self.isLoading = false
            }
        }
    }
}