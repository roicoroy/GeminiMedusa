
import Foundation

class ProductDetailsViewModel: ObservableObject {
    @Published var product: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let productService = ProductService()

    func fetchProduct(withId id: String) {
        isLoading = true
        errorMessage = nil
        productService.getProduct(withId: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let product):
                    self?.product = product
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
