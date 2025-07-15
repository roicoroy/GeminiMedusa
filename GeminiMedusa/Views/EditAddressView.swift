import SwiftUI

struct EditAddressView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var isShowingEditAddressSheet: Bool

    @State private var addressName: String
    @State private var company: String
    @State private var firstName: String
    @State private var lastName: String
    @State private var address1: String
    @State private var address2: String
    @State private var city: String
    @State private var countryCode: String
    @State private var province: String
    @State private var postalCode: String
    @State private var phone: String
    @State private var isDefaultShipping: Bool
    @State private var isDefaultBilling: Bool

    init(viewModel: ProfileViewModel, isShowingEditAddressSheet: Binding<Bool>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _isShowingEditAddressSheet = isShowingEditAddressSheet

        _addressName = State(initialValue: viewModel.addressToEdit?.addressName ?? "")
        _company = State(initialValue: viewModel.addressToEdit?.company ?? "")
        _firstName = State(initialValue: viewModel.addressToEdit?.firstName ?? "")
        _lastName = State(initialValue: viewModel.addressToEdit?.lastName ?? "")
        _address1 = State(initialValue: viewModel.addressToEdit?.address1 ?? "")
        _address2 = State(initialValue: viewModel.addressToEdit?.address2 ?? "")
        _city = State(initialValue: viewModel.addressToEdit?.city ?? "")
        _countryCode = State(initialValue: viewModel.addressToEdit?.countryCode ?? "")
        _province = State(initialValue: viewModel.addressToEdit?.province ?? "")
        _postalCode = State(initialValue: viewModel.addressToEdit?.postalCode ?? "")
        _phone = State(initialValue: viewModel.addressToEdit?.phone ?? "")
        _isDefaultShipping = State(initialValue: viewModel.addressToEdit?.isDefaultShipping ?? false)
        _isDefaultBilling = State(initialValue: viewModel.addressToEdit?.isDefaultBilling ?? false)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(viewModel.addressToEdit == nil ? "Add New Address" : "Edit Address")) {
                    TextField("Address Name (e.g., Home, Work)", text: $addressName)
                    TextField("Company (Optional)", text: $company)
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Address Line 1", text: $address1)
                    TextField("Address Line 2 (Optional)", text: $address2)
                    TextField("City", text: $city)
                    TextField("Country Code (e.g., US, GB)", text: $countryCode)
                    TextField("Province/State (Optional)", text: $province)
                    TextField("Postal Code", text: $postalCode)
                    TextField("Phone (Optional)", text: $phone)

                    Toggle("Set as Default Shipping Address", isOn: $isDefaultShipping)
                    Toggle("Set as Default Billing Address", isOn: $isDefaultBilling)
                }

                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    let addressRequest = AddressRequest(
                        addressName: addressName.isEmpty ? nil : addressName,
                        isDefaultShipping: isDefaultShipping,
                        isDefaultBilling: isDefaultBilling,
                        company: company.isEmpty ? nil : company,
                        firstName: firstName,
                        lastName: lastName,
                        address1: address1,
                        address2: address2.isEmpty ? nil : address2,
                        city: city,
                        countryCode: countryCode,
                        province: province.isEmpty ? nil : province,
                        postalCode: postalCode,
                        phone: phone.isEmpty ? nil : phone
                    )

                    if let addressId = viewModel.addressToEdit?.id {
                        viewModel.updateAddress(addressId: addressId, address: addressRequest, isDefaultShipping: isDefaultShipping, isDefaultBilling: isDefaultBilling)
                    } else {
                        viewModel.addAddress(address: addressRequest, isDefaultShipping: isDefaultShipping, isDefaultBilling: isDefaultBilling)
                    }
                    isShowingEditAddressSheet = false
                }) {
                    Text(viewModel.addressToEdit == nil ? "Add Address" : "Save Changes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
            .navigationTitle(viewModel.addressToEdit == nil ? "Add Address" : "Edit Address")
            .navigationBarItems(leading: Button("Cancel") {
                isShowingEditAddressSheet = false
            })
        }
    }
}