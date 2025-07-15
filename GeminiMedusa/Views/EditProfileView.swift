import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var isShowingEditProfileSheet: Bool

    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String

    init(viewModel: ProfileViewModel, isShowingEditProfileSheet: Binding<Bool>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _isShowingEditProfileSheet = isShowingEditProfileSheet
        _firstName = State(initialValue: viewModel.customer?.firstName ?? "")
        _lastName = State(initialValue: viewModel.customer?.lastName ?? "")
        _email = State(initialValue: viewModel.customer?.email ?? "")
        _phone = State(initialValue: viewModel.customer?.phone ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Personal Details")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }

                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.updateCustomer(firstName: firstName, lastName: lastName, email: email, phone: phone)
                    isShowingEditProfileSheet = false
                }) {
                    Text("Save Changes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)

                Section(header: Text("Shipping Address")) {
                    if let shippingAddress = viewModel.defaultShippingAddress {
                        VStack(alignment: .leading) {
                            Text(shippingAddress.addressName ?? "Default Shipping Address")
                                .font(.headline)
                            Text(shippingAddress.formattedAddress)
                        }
                        HStack {
                            Button("Edit") {
                                viewModel.addressToEdit = shippingAddress
                                viewModel.showAddressEditSheet = true
                            }
                            Spacer()
                            if shippingAddress.id != viewModel.customer?.defaultShippingAddressId {
                                Button("Set as Default") {
                                    viewModel.setAddressAsDefault(addressId: shippingAddress.id, type: .shipping)
                                }
                            }
                        }
                    } else {
                        Text("No default shipping address set.")
                    }
                }

                Section(header: Text("Billing Address")) {
                    if let billingAddress = viewModel.defaultBillingAddress {
                        VStack(alignment: .leading) {
                            Text(billingAddress.addressName ?? "Default Billing Address")
                                .font(.headline)
                            Text(billingAddress.formattedAddress)
                        }
                        HStack {
                            Button("Edit") {
                                viewModel.addressToEdit = billingAddress
                                viewModel.showAddressEditSheet = true
                            }
                            Spacer()
                            if billingAddress.id != viewModel.customer?.defaultBillingAddressId {
                                Button("Set as Default") {
                                    viewModel.setAddressAsDefault(addressId: billingAddress.id, type: .billing)
                                }
                            }
                        }
                    } else {
                        Text("No default billing address set.")
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(leading: Button("Cancel") {
                isShowingEditProfileSheet = false
            })
            .sheet(isPresented: $viewModel.showAddressEditSheet) {
                EditAddressView(viewModel: viewModel, isShowingEditAddressSheet: $viewModel.showAddressEditSheet)
            }
        }
    }
}
