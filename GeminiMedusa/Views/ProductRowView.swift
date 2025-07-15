import SwiftUI

struct ProductRowView: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService
    let product: ProductWithPrice

    var body: some View {
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
                if let calculatedPrice = product.variants?.first?.calculatedPrice {
                    Text("Price: \(formatPrice(calculatedPrice.calculatedAmount, currencyCode: calculatedPrice.currencyCode))")
                        .font(.footnote)
                        .fontWeight(.bold)
                }
            }
            Spacer()
            Button(action: {
                if let variantId = product.variants?.first?.id, let regionId = regionService.selectedRegionId {
                    cartService.addLineItem(variantId: variantId, quantity: 1, regionId: regionId)
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}
