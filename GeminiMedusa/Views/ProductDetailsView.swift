
import SwiftUI
import Foundation

struct ProductDetailsView: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService
    @StateObject var viewModel = ProductDetailsViewModel()
    let productId: String

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

                    if let calculatedPrice = product.variants?.first?.calculatedPrice {
                        Text("Price: \(formatPrice(calculatedPrice.calculatedAmount, currencyCode: calculatedPrice.currencyCode))")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }

                    Button(action: {
                        if let product = viewModel.product, let variantId = product.variants?.first?.id, let regionId = regionService.selectedRegionId {
                            cartService.addLineItem(variantId: variantId, quantity: 1, regionId: regionId)
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
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailsView(productId: "prod_01J12Y0G0G0G0G0G0G0G0G0G0G") // Replace with a valid product ID for preview
        }
    }
}
