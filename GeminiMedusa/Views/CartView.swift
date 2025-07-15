import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartService: CartService
    @EnvironmentObject var regionService: RegionService
    @State private var isOrderConfirmationActive = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    if let cart = cartService.currentCart, let items = cart.items, !items.isEmpty {
                        CartItemsSection()
                        OrderSummarySection(cart: cart, currencyCode: regionService.selectedRegionCurrency)
                        CustomerInfoSection(cart: cart)
                        if let shippingAddress = cart.shippingAddress {
                            ShippingAddressSection(shippingAddress: shippingAddress)
                        }
                        if let billingAddress = cart.billingAddress {
                            BillingAddressSection(billingAddress: billingAddress)
                        }
                    } else {
                        Text("Your cart is empty.")
                            .foregroundColor(.gray)
                    }
                }

//                if cartService.currentCart?.items?.isEmpty == false {
//                    Button(action: {
//                        cartService.completeCart()
//                    }) {
//                        Text("Complete Order")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                }

//                if let order = cartService.completedOrder {
//                    NavigationLink(destination: OrderConfirmationView(viewModel: self.createOrderConfirmationViewModel(order: order)), isActive: $isOrderConfirmationActive) {
//                        EmptyView()
//                    }
//                }
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
//            .onReceive(cartService.$completedOrder) { order in
//                if order != nil {
//                    isOrderConfirmationActive = true
//                }
//            }
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
