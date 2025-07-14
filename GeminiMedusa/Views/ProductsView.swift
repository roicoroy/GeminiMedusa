
//
//  ProductsView.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import SwiftUI
import Foundation

struct ProductsView: View {
    @EnvironmentObject var regionService: RegionService
    @StateObject var viewModel = ProductsViewModel()
    @State private var showingRegionSelection = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Products...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.products.isEmpty {
                    Text("No products found.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.products) {
                        product in
                        NavigationLink(destination: makeProductDetailsView(for: product)) {
                            ProductRowView(product: product)
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingRegionSelection = true
                    }) {
                        Image(systemName: "globe")
                        Text(regionService.selectedCountry?.label ?? "Select Region")
                    }
                }
            }
            .sheet(isPresented: $showingRegionSelection) {
                RegionSelectionView(regionService: regionService, isPresented: $showingRegionSelection)
            }
            .onAppear {
                if let regionId = regionService.selectedRegionId {
                    viewModel.fetchProducts(regionId: regionId)
                } else {
                    showingRegionSelection = true
                }
            }
            .onChange(of: regionService.selectedRegionId) { newRegionId in
                if let regionId = newRegionId {
                    viewModel.fetchProducts(regionId: regionId)
                }
            }
        }
    }

    private func makeProductDetailsView(for product: ProductWithPrice) -> some View {
        ProductDetailsView(productId: product.id, productsViewModel: viewModel)
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
            .environmentObject(RegionService())
            .environmentObject(ProductsViewModel())
    }
}
