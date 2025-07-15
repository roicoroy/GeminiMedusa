import SwiftUI

struct ShippingAddressSection: View {
    let shippingAddress: CartAddress

    var body: some View {
        Section(header: Text("Shipping Address")) {
            Text(shippingAddress.fullName)
            Text(shippingAddress.fullAddress)
            Text(shippingAddress.phone ?? "N/A")
        }
    }
}