
//
//  ProductsView.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import SwiftUI

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
                        HStack(alignment: .top) {
                            if let thumbnailURLString = product.thumbnail,
                               let url = URL(string: thumbnailURLString) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }

                            VStack(alignment: .leading) {
                                Text(product.title)
                                    .font(.headline)
                                Text(product.description ?? "No description")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                if let price = product.variants?.first?.calculatedPrice?.calculatedAmount,
                                   let currencyCode = product.variants?.first?.calculatedPrice?.currencyCode {
                                    Text("Price: \(formatPrice(price, currencyCode: currencyCode))")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                }
                            }
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
                RegionSelectionView()
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
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
            .environmentObject(RegionService())
    }
}
