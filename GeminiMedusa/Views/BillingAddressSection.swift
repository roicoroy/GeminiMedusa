import SwiftUI

struct BillingAddressSection: View {
    let billingAddress: CartAddress

    var body: some View {
        Section(header: Text("Billing Address")) {
            Text(billingAddress.fullName)
            Text(billingAddress.fullAddress)
            Text(billingAddress.phone)
        }
    }
}
