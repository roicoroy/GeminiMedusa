import SwiftUI

struct DebugView: View {
    @EnvironmentObject var regionService: RegionService
    @EnvironmentObject var authService: AuthService
    @State private var medusaCartContent: String = "Loading..."
    @State private var selectedRegionInfo: String = "Not selected"
    @State private var selectedCountryInfo: String = "Not selected"
    @State private var customerInfo: String = "Not loaded"

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

                Text("Selected Region:")
                    .font(.headline)
                Text(selectedRegionInfo)
                    .font(.footnote)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                Text("Selected Country:")
                    .font(.headline)
                Text(selectedCountryInfo)
                    .font(.footnote)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                Text("Customer Info:")
                    .font(.headline)
                ScrollView {
                    Text(customerInfo)
                        .font(.footnote)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Debug Info")
            .onAppear(perform: loadDebugInfo)
            .onChange(of: authService.customer) { _ in
                loadDebugInfo()
            }
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

        if let region = regionService.selectedRegion {
            selectedRegionInfo = "ID: \(region.id), Name: \(region.name ?? "N/A"), Currency: \(region.currencyCode ?? "N/A")"
        } else {
            selectedRegionInfo = "No region selected."
        }

        if let country = regionService.selectedCountry {
            selectedCountryInfo = "Code: \(country.country), Name: \(country.label), Region ID: \(country.regionId)"
        } else {
            selectedCountryInfo = "No country selected."
        }

        if let customer = authService.customer {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(customer)
                customerInfo = String(data: data, encoding: .utf8) ?? "Could not encode customer data."
            } catch {
                customerInfo = "Error encoding customer data: \(error.localizedDescription)"
            }
        } else {
            customerInfo = "No customer data available."
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
            .environmentObject(RegionService())
            .environmentObject(AuthService())
    }
}
