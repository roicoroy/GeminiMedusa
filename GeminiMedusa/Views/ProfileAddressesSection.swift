import SwiftUI

struct ProfileAddressesSection: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showingAddAddressSheet: Bool

    var body: some View {
        Section(header: Text("Addresses")) {
            ForEach(viewModel.customer?.addresses ?? []) { address in
                VStack(alignment: .leading) {
                    Text(address.firstName ?? "" + " " + (address.lastName ?? ""))
                    Text(address.address1)
                    if !(address.address2 ?? "").isEmpty {
                        Text(address.address2 ?? "")
                    }
                    Text("\(address.city), \(address.province ?? "") \(address.postalCode)")
                    Text(address.countryCode)
                    if !(address.phone ?? "").isEmpty {
                        Text(address.phone ?? "")
                    }
                    HStack {
                        if address.id == viewModel.customer?.defaultShippingAddressId {
                            Text("Default Shipping")
                                .font(.caption)
                                .padding(.horizontal, 5)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(5)
                        }
                        if address.id == viewModel.customer?.defaultBillingAddressId {
                            Text("Default Billing")
                                .font(.caption)
                                .padding(.horizontal, 5)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deleteAddress(addressId: address.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Button {
                        viewModel.addressToEdit = address
                        showingAddAddressSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
            Button("Add New Address") {
                viewModel.addressToEdit = nil // Clear for new address
                showingAddAddressSheet = true
            }
        }
    }
}