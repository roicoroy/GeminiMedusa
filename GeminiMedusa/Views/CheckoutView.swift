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
            VStack {
                Text("Address management is now handled in your Profile.")
                    .font(.headline)
                    .padding()
                
                Button(action: {
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
