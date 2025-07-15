import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var customer: Customer? // The customer object to edit
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showAddressEditSheet = false
    @Published var addressToEdit: Address? // For editing existing address

    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthService = AuthService()) {
        self.authService = authService
        setupBindings()
        fetchCustomerProfile()
    }

    private func setupBindings() {
        authService.$customer
            .assign(to: \.customer, on: self)
            .store(in: &cancellables)

        authService.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        authService.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }

    func fetchCustomerProfile() {
        authService.fetchCustomerProfile()
    }

    func updateCustomer(firstName: String, lastName: String, email: String, phone: String) {
        guard let customerId = customer?.id else {
            errorMessage = "Customer ID not found."
            return
        }
        isLoading = true
        authService.updateCustomer(customerId: customerId, firstName: firstName, lastName: lastName, email: email, phone: phone) { [weak self] success, message in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.errorMessage = message
                }
            }
        }
    }

    func addAddress(address: AddressRequest, isDefaultShipping: Bool, isDefaultBilling: Bool) {
        isLoading = true
        authService.addAddress(addressName: address.addressName, company: address.company, firstName: address.firstName!, lastName: address.lastName!, address1: address.address1, address2: address.address2, city: address.city, countryCode: address.countryCode, province: address.province, postalCode: address.postalCode, phone: address.phone, isDefaultShipping: isDefaultShipping, isDefaultBilling: isDefaultBilling) { [weak self] success, message in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.errorMessage = message
                } else {
                    self?.fetchCustomerProfile() // Refresh customer data after adding address
                }
            }
        }
    }

    func updateAddress(addressId: String, address: AddressRequest, isDefaultShipping: Bool, isDefaultBilling: Bool) {
        isLoading = true
        authService.updateCustomerAddress(addressId: addressId, addressName: address.addressName, company: address.company, firstName: address.firstName!, lastName: address.lastName!, address1: address.address1, address2: address.address2, city: address.city, countryCode: address.countryCode, province: address.province, postalCode: address.postalCode, phone: address.phone, isDefaultShipping: isDefaultShipping, isDefaultBilling: isDefaultBilling) { [weak self] success, message in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.errorMessage = message
                } else {
                    self?.fetchCustomerProfile() // Refresh customer data after updating address
                }
            }
        }
    }

    func deleteAddress(addressId: String) {
        isLoading = true
        authService.deleteAddress(addressId: addressId) { [weak self] success, message in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.errorMessage = message
                } else {
                    self?.fetchCustomerProfile() // Refresh customer data after deleting address
                }
            }
        }
    }

    func setAsDefaultShipping(addressId: String) {
        // This logic might need to be handled by the backend or by updating the customer object directly
        // For now, we'll simulate by updating the local customer object if possible
        if var currentCustomer = customer {
            if let index = currentCustomer.shippingAddresses.firstIndex(where: { $0.id == addressId }) {
                // Logic to set as default shipping address (e.g., move to front of array or set a flag)
                // This depends on how your backend handles default addresses
                // For now, we'll just re-fetch the profile to reflect changes from backend
                fetchCustomerProfile()
            }
        }
    }

    func setAsDefaultBilling(addressId: String) {
        // This logic might need to be handled by the backend or by updating the customer object directly
        // For now, we'll simulate by updating the local customer object if possible
        if var currentCustomer = customer {
            if let index = currentCustomer.billingAddresses.firstIndex(where: { $0.id == addressId }) {
                // Logic to set as default billing address (e.g., move to front of array or set a flag)
                // This depends on how your backend handles default addresses
                // For now, we'll just re-fetch the profile to reflect changes from backend
                fetchCustomerProfile()
            }
        }
    }
}
