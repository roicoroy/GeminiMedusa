import SwiftUI

struct CartItemsSection: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService

    var body: some View {
        Section(header: Text("Items")) {
            ForEach(cartService.currentCart?.items ?? []) { item in
                CartItemRowView(item: item, currencyCode: regionService.selectedRegionCurrency)
            }
        }
    }
}