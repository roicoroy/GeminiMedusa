
import SwiftUI
import Foundation

struct ProductDetailsView: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService
    @StateObject var viewModel = ProductDetailsViewModel()
    let productId: String
    
    @State private var showingAddToCartAlert = false
    @State private var selectedVariant: ProductVariant?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if let product = viewModel.product {
                    if let imageUrl = product.thumbnail, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .cornerRadius(10)
                            .foregroundColor(.gray)
                    }
                    
                    Text(product.title ?? "Unknown Product")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let description = product.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    if let product = viewModel.product {
                        if product.variants?.count ?? 0 > 1 {
                            Picker("Select Variant", selection: $selectedVariant) {
                                ForEach(product.variants ?? [], id: \.id) { variant in
                                    Text(variant.title ?? "Unknown Variant")
                                        .tag(variant as ProductVariant?)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: selectedVariant) { newVariant in
                                // Update price display based on newVariant
                            }
                        }
                        
                        if let price = selectedVariant?.calculatedPrice ?? product.variants?.first?.calculatedPrice {
                            Text("Price: \(formatPrice(price.calculatedAmount, currencyCode: price.currencyCode))")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Button(action: {
                            if let variant = selectedVariant ?? product.variants?.first, let regionId = regionService.selectedRegionId {
                                cartService.addLineItem(variantId: variant.id, quantity: 1, regionId: regionId) { success in
                                    if success {
                                        showingAddToCartAlert = true
                                    }
                                }
                            }
                        }) {
                            Text("Add to Cart")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Add more product details here as needed
                } else {
                    Text("Product not found.")
                }
            }
            .padding()
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchProduct(withId: productId)
        }
        .onChange(of: viewModel.product) {
            if let product = viewModel.product, let firstVariant = product.variants?.first {
                selectedVariant = firstVariant
            }
        }
        .alert("Success", isPresented: $showingAddToCartAlert) {
            Button("OK") { }
        } message: {
            Text("Product added to cart!")
        }
    }
    
    struct ProductDetailsView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ProductDetailsView(productId: "prod_01J12Y0G0G0G0G0G0G0G0G0G0G") // Replace with a valid product ID for preview
            }
        }
    }
}
