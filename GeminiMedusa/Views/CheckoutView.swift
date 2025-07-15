import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartService: CartService
    @StateObject var viewModel: CheckoutViewModel
    @Environment(\.presentationMode) var presentationMode

    init(cartService: CartService) {
        _viewModel = StateObject(wrappedValue: CheckoutViewModel(cartService: cartService))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Shipping Address")) {
                    TextField("First Name", text: Binding(get: { viewModel.shippingAddress.firstName ?? "" }, set: { viewModel.shippingAddress.firstName = $0 }))
                    TextField("Last Name", text: Binding(get: { viewModel.shippingAddress.lastName }, set: { viewModel.shippingAddress.lastName = $0 }))
                    TextField("Address 1", text: Binding(get: { viewModel.shippingAddress.address1 ?? "" }, set: { viewModel.shippingAddress.address1 = $0 }))
                    TextField("Address 2", text: Binding(get: { viewModel.shippingAddress.address2 ?? "" }, set: { viewModel.shippingAddress.address2 = $0 }))
                    TextField("City", text: Binding(get: { viewModel.shippingAddress.city ?? "" }, set: { viewModel.shippingAddress.city = $0 }))
                    TextField("Province", text: Binding(get: { viewModel.shippingAddress.province ?? "" }, set: { viewModel.shippingAddress.province = $0 }))
                    TextField("Postal Code", text: Binding(get: { viewModel.shippingAddress.postalCode ?? "" }, set: { viewModel.shippingAddress.postalCode = $0 }))
                    TextField("Country Code", text: Binding(get: { viewModel.shippingAddress.countryCode ?? "" }, set: { viewModel.shippingAddress.countryCode = $0 }))
                    TextField("Phone", text: Binding(get: { viewModel.shippingAddress.phone ?? "" }, set: { viewModel.shippingAddress.phone = $0 }))
                }

                Section(header: Text("Billing Address")) {
                    Toggle(isOn: Binding(get: { viewModel.shippingAddress == viewModel.billingAddress }, set: { isSame in
                        if isSame {
                            viewModel.billingAddress = viewModel.shippingAddress
                        } else {
                            viewModel.billingAddress = CartAddress()
                        }
                    })) {
                        Text("Same as Shipping Address")
                    }
                    if viewModel.shippingAddress != viewModel.billingAddress {
                        TextField("First Name", text: Binding(get: { viewModel.billingAddress.firstName ?? "" }, set: { viewModel.billingAddress.firstName = $0 }))
                        TextField("Last Name", text: Binding(get: { viewModel.billingAddress.lastName ?? "" }, set: { viewModel.billingAddress.lastName = $0 }))
                        TextField("Address 1", text: Binding(get: { viewModel.billingAddress.address1 ?? "" }, set: { viewModel.billingAddress.address1 = $0 }))
                        TextField("Address 2", text: Binding(get: { viewModel.billingAddress.address2 ?? "" }, set: { viewModel.billingAddress.address2 = $0 }))
                        TextField("City", text: Binding(get: { viewModel.billingAddress.city ?? "" }, set: { viewModel.billingAddress.city = $0 }))
                        TextField("Province", text: Binding(get: { viewModel.billingAddress.province ?? "" }, set: { viewModel.billingAddress.province = $0 }))
                        TextField("Postal Code", text: Binding(get: { viewModel.billingAddress.postalCode ?? "" }, set: { viewModel.billingAddress.postalCode = $0 }))
                        TextField("Country Code", text: Binding(get: { viewModel.billingAddress.countryCode ?? "" }, set: { viewModel.billingAddress.countryCode = $0 }))
                        TextField("Phone", text: Binding(get: { viewModel.billingAddress.phone ?? "" }, set: { viewModel.billingAddress.phone = $0 }))
                    }
                }

                Button(action: {
                    viewModel.updateCartAddresses()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Continue to Payment")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
            .navigationTitle("Checkout")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(cartService: CartService())
            .environmentObject(CartService())
    }
}
