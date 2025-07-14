
import SwiftUI

struct ProductPriceSelectComponent: View {
    let product: Product
    @Binding var selectedVariant: ProductWithPriceVariant?
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService
    @Binding var showingAddToCartAlert: Bool

    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
            if product.variants?.count ?? 0 > 1 {
                Picker("Select Variant", selection: $selectedVariant) {
                    ForEach(product.variants ?? [], id: \.id) { variant in
                        ProductVariantRowView(variant: variant, currencyCode: regionService.selectedRegionCurrency ?? "GBP")
                            .tag(variant as ProductWithPriceVariant?)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: selectedVariant) { newVariant in
                    // Update price display based on newVariant
                    print(newVariant ?? "No variant selected")
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
    }
}
