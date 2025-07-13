import SwiftUI

struct DebugView: View {
    @State private var medusaCartContent: String = "Loading..."

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text("User Defaults Content (medusa_cart):")
                    .font(.headline)
                ScrollView {
                    Text(medusaCartContent)
                        .font(.footnote)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Debug Info")
            .onAppear(perform: loadDebugInfo)
        }
    }

    private func loadDebugInfo() {
        if let cartData = UserDefaults.standard.data(forKey: "medusa_cart") {
            if let jsonString = String(data: cartData, encoding: .utf8) {
                medusaCartContent = jsonString
            } else {
                medusaCartContent = "Could not decode cart data as UTF-8 string."
            }
        } else {
            medusaCartContent = "No 'medusa_cart' found in UserDefaults."
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
