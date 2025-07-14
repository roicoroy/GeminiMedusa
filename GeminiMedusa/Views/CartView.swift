import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService
    @State private var isOrderConfirmationActive = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    if let items = cartService.currentCart?.items, !items.isEmpty {
                        Section(header: Text("Items")) {
                            ForEach(items) { item in
                                HStack {
                                    Text(item.title ?? "Unknown Item")
                                    Spacer()
                                    Text("Quantity: \(item.quantity)")
                                    if let currencyCode = regionService.selectedRegionCurrency {
                                        Text(formatPrice(item.unitPrice * item.quantity, currencyCode: currencyCode))
                                    }
                                    Button(action: {
                                        cartService.removeLineItem(lineItemId: item.id)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }

                        if let cart = cartService.currentCart {
                            Section(header: Text("Order Summary")) {
                                HStack {
                                    Text("Subtotal:")
                                    Spacer()
                                    Text(cart.formattedSubtotal(currencyCode: regionService.selectedRegionCurrency))
                                }
                                HStack {
                                    Text("Shipping:")
                                    Spacer()
                                    Text(cart.formattedShippingTotal(currencyCode: regionService.selectedRegionCurrency))
                                }
                                HStack {
                                    Text("Tax:")
                                    Spacer()
                                    Text(cart.formattedTaxTotal(currencyCode: regionService.selectedRegionCurrency))
                                }
                                HStack {
                                    Text("Total:")
                                    Spacer()
                                    Text(cart.formattedTotal(currencyCode: regionService.selectedRegionCurrency))
                                        .font(.headline)
                                }
                            }

                            Section(header: Text("Customer Information")) {
                                Text("Email: \(cart.email ?? "N/A")")
                                Text("Status: \(cart.customerStatus)")
                            }

                            if let shippingAddress = cart.shippingAddress {
                                Section(header: Text("Shipping Address")) {
                                    Text(shippingAddress.fullName)
                                    Text(shippingAddress.fullAddress)
                                    Text(shippingAddress.phone ?? "N/A")
                                }
                            }

                            if let billingAddress = cart.billingAddress {
                                Section(header: Text("Billing Address")) {
                                    Text(billingAddress.fullName)
                                    Text(billingAddress.fullAddress)
                                    Text(billingAddress.phone ?? "N/A")
                                }
                            }
                        }
                    } else {
                        Text("Your cart is empty.")
                            .foregroundColor(.gray)
                    }
                }

                if cartService.currentCart?.items?.isEmpty == false {
                    Button(action: {
                        cartService.completeCart()
                    }) {
                        Text("Complete Order")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                if let order = cartService.completedOrder {
                    NavigationLink(destination: OrderConfirmationView(viewModel: self.createOrderConfirmationViewModel(order: order)), isActive: $isOrderConfirmationActive) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("Shopping Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        cartService.clearCart()
                    }) {
                        Text("Clear Cart")
                    }
                }
            }
            .onReceive(cartService.$completedOrder) { order in
                if order != nil {
                    isOrderConfirmationActive = true
                }
            }
        }
    }

    private func createOrderConfirmationViewModel(order: Order) -> OrderConfirmationViewModel {
        let viewModel = OrderConfirmationViewModel()
        viewModel.setOrder(order: order)
        return viewModel
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartService())
            .environmentObject(RegionService())
    }
}
