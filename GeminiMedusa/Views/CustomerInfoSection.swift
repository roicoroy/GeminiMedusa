import SwiftUI

struct CustomerInfoSection: View {
    let cart: Cart

    var body: some View {
        Section(header: Text("Customer Information")) {
            Text("Email: \(cart.email ?? "N/A")")
            Text("Status: \(cart.customerStatus)")
        }
    }
}