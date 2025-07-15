import SwiftUI

struct ProfileAddressesSection: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showingAddAddressSheet: Bool

    var body: some View {
        Section(header: Text("Addresses")) {
            ForEach(viewModel.customer?.addresses ?? []) { address in
                VStack(alignment: .leading) {
                    Text(address.formattedAddress)
                    HStack {
                        if address.isDefaultShipping {
                            Text("Selected (Shipping)")
                                .font(.caption)
                                .padding(.horizontal, 5)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(5)
                        } else {
                            Button("Set as Default Shipping") {
                                viewModel.setAddressAsDefault(addressId: address.id, type: .shipping)
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }

                        if address.isDefaultShipping {
                            Text("Selected (Billing)")
                                .font(.caption)
                                .padding(.horizontal, 5)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(5)
                        } else {
                            Button("Set as Default Billing") {
                                viewModel.setAddressAsDefault(addressId: address.id, type: .billing)
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
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
