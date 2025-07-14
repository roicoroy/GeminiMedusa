import Foundation
import Combine

class ProductService: ObservableObject {
    @Published var productsWithPrice: [ProductWithPrice] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Initial fetch will be handled by the views that require products with prices
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func fetchProductsWithPrice(regionId: String, limit: Int = 50, offset: Int = 0) {
        isLoading = true
        errorMessage = nil
        
        let endpoint = "products?fields=*variants.calculated_price&region_id=\(regionId)&limit=\(limit)&offset=\(offset)"
        
        NetworkManager.shared.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch products with price: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] (response: ProductWithPriceResponse) in
                self?.productsWithPrice = response.products
            })
            .store(in: &cancellables)
    }
    
    

    func getProduct(withId id: String, completion: @escaping (Result<Product, Error>) -> Void) {
        let endpoint = "products/\(id)"
        NetworkManager.shared.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { comp in
                if case .failure(let error) = comp {
                    completion(.failure(error))
                }
            }, receiveValue: { (response: ProductResponse) in
                completion(.success(response.product))
            })
            .store(in: &cancellables)
    }
}

struct ProductResponse: Codable {
    let product: Product
}
        

