import Foundation
import Combine

class CheckoutViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let cartService: CartService
    private var cancellables = Set<AnyCancellable>()

    init(cartService: CartService = CartService()) {
        self.cartService = cartService
    }
}