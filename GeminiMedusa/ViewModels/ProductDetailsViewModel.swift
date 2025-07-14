
import Foundation

class ProductDetailsViewModel: ObservableObject {
    @Published var product: ProductWithPrice?
    @Published var isLoading = false
    @Published var errorMessage: String?

    var allProducts: [ProductWithPrice] = []

    init(allProducts: [ProductWithPrice]) {
        self.allProducts = allProducts
    }

    func fetchProduct(withId id: String) {
        isLoading = true
        errorMessage = nil
        if let product = allProducts.first(where: { $0.id == id }) {
            self.product = product
            self.isLoading = false
        } else {
            self.errorMessage = "Product not found in local cache."
            self.isLoading = false
        }
    }
}
