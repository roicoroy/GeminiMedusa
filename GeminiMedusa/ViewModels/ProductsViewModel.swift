
//
//  ProductsViewModel.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import Foundation
import Combine

class ProductsViewModel: ObservableObject {
    @Published var products: [ProductWithPrice] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let productService: ProductService
    private var cancellables = Set<AnyCancellable>()
    
    init(productService: ProductService = ProductService()) {
        self.productService = productService
        setupBindings()
    }
    
    private func setupBindings() {
        productService.$productsWithPrice
            .assign(to: \.products, on: self)
            .store(in: &cancellables)
        
        productService.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        productService.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    func fetchProducts(regionId: String) {
        productService.fetchProductsWithPrice(regionId: regionId)
    }
}
