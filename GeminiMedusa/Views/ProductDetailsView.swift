
import SwiftUI
import Foundation

struct ProductDetailsView: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService
    @StateObject var viewModel = ProductDetailsViewModel()
    let productId: String
    
    @State private var showingAddToCartAlert = false
    @State private var selectedVariant: ProductWithPriceVariant?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if let product = viewModel.product {
                    ProductImageView(thumbnail: product.thumbnail)
                    
                    Text(product.title ?? "Unknown Product")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let description = product.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    ProductPriceSelectComponent(product: product, selectedVariant: $selectedVariant, showingAddToCartAlert: $showingAddToCartAlert)
                    
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
