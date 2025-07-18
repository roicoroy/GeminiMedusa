import Foundation
import Combine

class AuthService: ObservableObject {
    
    @Published var currentCustomer: Customer?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var customer: Customer?

    private var cancellables = Set<AnyCancellable>()
    private let authWatcher: AuthenticationWatcherService
    
    init(authWatcher: AuthenticationWatcherService = AuthenticationWatcherService()) {
        self.authWatcher = authWatcher
        checkAuthenticationStatus()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func checkAuthenticationStatus() {
        print("AuthService: Checking authentication status...")
        if let customerData = UserDefaults.standard.data(forKey: "customer"),
           let customer = try? JSONDecoder().decode(Customer.self, from: customerData) {
            DispatchQueue.main.async { [weak self] in
                self?.currentCustomer = customer
                
                self?.customer = customer // Ensure @Published customer is also set on launch
                print("AuthService: Customer loaded from UserDefaults. ID: \(customer.id)")
            }
        } else {
            print("AuthService: No customer data found in UserDefaults.")
        }
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, phone: String) {
        isLoading = true
        errorMessage = nil
        
        let authPayload = AuthRegisterPayload(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: phone
        )
        
        guard let body = try? JSONEncoder().encode(authPayload) else {
            errorMessage = "Failed to encode registration request"
            isLoading = false
            return
        }
        
        NetworkManager.shared.request(endpoint: "auth/customer/emailpass/register", method: "POST", body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Registration failed: \(error.localizedDescription)"
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] (response: AuthRegisterResponse) in
                self?.createCustomerProfile(token: response.token, email: email, firstName: firstName, lastName: lastName, phone: phone, password: password)
            })
            .store(in: &cancellables)
    }
    
    private func createCustomerProfile(token: String, email: String, firstName: String, lastName: String, phone: String, password: String) {
        let customerPayload = CustomerCreationPayload(
            email: email,
            firstName: firstName,
            lastName: lastName,
            phone: phone
        )
        
        guard let body = try? JSONEncoder().encode(customerPayload) else {
            errorMessage = "Failed to encode customer creation request"
            isLoading = false
            return
        }
        
        NetworkManager.shared.request(endpoint: "customers", method: "POST", body: body, requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Customer creation failed: \(error.localizedDescription)"
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] (response: CustomerResponse) in
                self?.loginAfterRegistration(email: email, password: password)
            })
            .store(in: &cancellables)
    }
    
    private func loginAfterRegistration(email: String, password: String) {
        print("AuthService: Attempting login after registration for email: \(email)")
        let loginRequest = CustomerLoginRequest(email: email, password: password)
        
        guard let body = try? JSONEncoder().encode(loginRequest) else {
            errorMessage = "Failed to encode login request"
            isLoading = false
            print("AuthService: Failed to encode login request for loginAfterRegistration")
            return
        }
        
        NetworkManager.shared.requestData(endpoint: "auth/customer/emailpass", method: "POST", body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Login after registration failed: \(error.localizedDescription)"
                    self?.isLoading = false
                    print("AuthService: Login after registration failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (data: Data) in
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        guard let token = json["token"] as? String else {
                            self?.errorMessage = "No token found in login response"
                            self?.isLoading = false
                            print("AuthService: No token found in login response for loginAfterRegistration")
                            return
                        }
                        UserDefaults.standard.set(token, forKey: "auth_token")
                        print("AuthService: Token saved for loginAfterRegistration: \(token)")
                        self?.fetchCustomerProfileAfterLogin()
                    } else {
                        self?.errorMessage = "Failed to parse login response"
                        self?.isLoading = false
                        print("AuthService: Failed to parse login response for loginAfterRegistration")
                    }
                } catch {
                    self?.errorMessage = "Failed to decode login response: \(error.localizedDescription)"
                    self?.isLoading = false
                    print("AuthService: Failed to decode login response for loginAfterRegistration: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
    
    func authenticate(email: String, password: String) {
        print("AuthService: Attempting authentication for email: \(email)")
        isLoading = true
        errorMessage = nil

        let loginRequest = CustomerLoginRequest(email: email, password: password)

        guard let body = try? JSONEncoder().encode(loginRequest) else {
            errorMessage = "Failed to encode login request"
            isLoading = false
            print("AuthService: Failed to encode login request for authenticate")
            return
        }

        NetworkManager.shared.requestData(endpoint: "auth/customer/emailpass", method: "POST", body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] comp in
                self?.isLoading = false
                if case .failure(let error) = comp {
                    self?.errorMessage = "Login failed: \(error.localizedDescription)"
                    print("AuthService: Authentication failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (data: Data) in
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        guard let token = json["token"] as? String else {
                            self?.errorMessage = "No token found in login response"
                            self?.isLoading = false
                            print("AuthService: No token found in login response for authenticate")
                            return
                        }
                        
                        UserDefaults.standard.set(token, forKey: "auth_token")
                        print("AuthService: Token saved for authenticate: \(token)")
                        self?.fetchCustomerProfileAfterLogin()
                    } else {
                        self?.errorMessage = "Failed to parse login response"
                        self?.isLoading = false
                        print("AuthService: Failed to parse login response for authenticate")
                    }
                } catch {
                    self?.errorMessage = "Failed to decode login response: \(error.localizedDescription)"
                    self?.isLoading = false
                    print("AuthService: Failed to decode login response for authenticate: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
    
//    func authenticate(email: String, password: String) {
//        isLoading = true
//        errorMessage = nil
//
//        let loginRequest = CustomerLoginRequest(email: email, password: password)
//
//        guard let body = try? JSONEncoder().encode(loginRequest) else {
//            errorMessage = "Failed to encode login request"
//            isLoading = false
//            return
//        }
//
//        NetworkManager.shared.requestData(endpoint: "auth/customer/emailpass", method: "POST", body: body)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] comp in
//                self?.isLoading = false
//                if case .failure(let error) = comp {
//                    self?.errorMessage = "Login failed: \(error.localizedDescription)"
//                }
//            }, receiveValue: { [weak self] data in
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        guard let token = json["token"] as? String else {
//                            self?.errorMessage = "No token found in login response"
//                            return
//                        }
//                        UserDefaults.standard.set(token, forKey: "auth_token")
//                        self?.fetchCustomerProfileAfterLogin()
//                    } else {
//                        self?.errorMessage = "Failed to parse login response"
//                    }
//                } catch {
//                    self?.errorMessage = "Failed to decode login response: \(error.localizedDescription)"
//                }
//            })
//            .store(in: &cancellables)
//    }

    private func fetchCustomerProfileAfterLogin() {
        print("AuthService: fetchCustomerProfileAfterLogin called.")
        NetworkManager.shared.request(endpoint: "customers/me", requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] comp in
                self?.isLoading = false
                if case .failure(let error) = comp {
                    self?.errorMessage = "Failed to fetch customer profile: \(error.localizedDescription)"
                    print("AuthService: Failed to fetch customer profile after login: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (response: CustomerResponse) in
                guard let self = self else { return }
                self.currentCustomer = response.customer
                
                self.customer = response.customer // Set the customer object
                self.saveCustomerData(response.customer)
                print("AuthService: Customer profile fetched and saved after login. Customer ID: \(response.customer.id)")
                self.authWatcher.checkTokenStatus() // Notify watcher about login
            })
            .store(in: &cancellables)
    }
    
    func fetchCustomerProfile() {
        print("AuthService: fetchCustomerProfile called.")
        NetworkManager.shared.requestData(endpoint: "customers/me", requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
                    print("AuthService: Failed to fetch profile: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (data: Data) in
                do {
                    let response = try JSONDecoder().decode(CustomerResponse.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.currentCustomer = response.customer
                        self.customer = response.customer // Update the @Published customer property
                        self.saveCustomerData(response.customer)
                        print("AuthService: Customer profile fetched and saved. Customer ID: \(response.customer.id)")
                    }
                    return
                } catch {
                    // Failed to decode as CustomerResponse, error message will be set below
                    print("AuthService: Failed to decode customer profile response: \(error.localizedDescription)")
                }
                
                self?.errorMessage = "Failed to parse customer profile response"
            })
            .store(in: &cancellables)
    }
    
    func updateCustomer(
        customerId: String,
        firstName: String,
        lastName: String,
        email: String,
        phone: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let customerUpdateRequest = CustomerUpdateRequest(
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            companyName: nil // Assuming companyName is not updated here
        )
        
        guard let body = try? JSONEncoder().encode(customerUpdateRequest) else {
            completion(false, "Failed to encode customer update request")
            print("AuthService: Failed to encode customer update request.")
            return
        }
        
        print("AuthService: Updating customer with ID: \(customerId), Payload: \(String(data: body, encoding: .utf8) ?? "N/A")")
        NetworkManager.shared.request(endpoint: "customers/\(customerId)", method: "POST", body: body, requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                if case .failure(let error) = completionResult {
                    completion(false, "Failed to update customer: \(error.localizedDescription)")
                    print("AuthService: Customer update failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (response: CustomerResponse) in
                guard let self = self else { return }
                self.customer = response.customer // Update the @Published customer property
                self.saveCustomerData(response.customer)
                print("AuthService: Customer updated successfully. New customer ID: \(response.customer.id)")
                completion(true, nil)
            })
            .store(in: &cancellables)
    }
    
    func addAddress(
        addressName: String?,
        company: String?,
        firstName: String,
        lastName: String,
        address1: String,
        address2: String?,
        city: String,
        countryCode: String,
        province: String?,
        postalCode: String,
        phone: String?,
        isDefaultShipping: Bool,
        isDefaultBilling: Bool,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let addressRequest = AddressRequest(
            addressName: addressName,
            isDefaultShipping: isDefaultShipping,
            isDefaultBilling: isDefaultBilling,
            company: company,
            firstName: firstName,
            lastName: lastName,
            address1: address1,
            address2: address2,
            city: city,
            countryCode: countryCode,
            province: province,
            postalCode: postalCode,
            phone: phone
        )
        
        guard let body = try? JSONEncoder().encode(addressRequest) else {
            completion(false, "Failed to encode address request")
            return
        }
        
        NetworkManager.shared.request(endpoint: "customers/me/addresses", method: "POST", body: body, requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionResult in
                if case .failure(let error) = completionResult {
                    
                    completion(false, "Failed to add address: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (response: AddressResponse) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.fetchCustomerProfile()
                }
                completion(true, nil)
            })
            .store(in: &cancellables)
    }
    
    
    
    func updateCustomerAddress(
        addressId: String,
        addressName: String?,
        company: String?,
        firstName: String,
        lastName: String,
        address1: String,
        address2: String?,
        city: String,
        countryCode: String,
        province: String?,
        postalCode: String,
        phone: String?,
        isDefaultShipping: Bool,
        isDefaultBilling: Bool,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let addressRequest = AddressRequest(
            addressName: addressName,
            isDefaultShipping: isDefaultShipping,
            isDefaultBilling: isDefaultBilling,
            company: company,
            firstName: firstName,
            lastName: lastName,
            address1: address1,
            address2: address2,
            city: city,
            countryCode: countryCode,
            province: province,
            postalCode: postalCode,
            phone: phone
        )
        
        guard let body = try? JSONEncoder().encode(addressRequest) else {
            completion(false, "Failed to encode address request")
            return
        }
        
        NetworkManager.shared.request(endpoint: "customers/me/addresses/\(addressId)", method: "POST", body: body, requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                if case .failure(let error) = completionResult {
                    
                    completion(false, "Failed to update address: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (response: AddressResponse) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.fetchCustomerProfile()
                }
                completion(true, nil)
            })
            .store(in: &cancellables)
    }
    
    func deleteAddress(addressId: String, completion: @escaping (Bool, String?) -> Void) {
        NetworkManager.shared.requestData(endpoint: "customers/me/addresses/\(addressId)", method: "DELETE", requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionResult in
                if case .failure(let error) = completionResult {
                    completion(false, "Failed to delete address: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (data: Data) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.fetchCustomerProfile()
                }
                completion(true, nil)
            })
            .store(in: &cancellables)
    }
    
    func logout() {
        print("AuthService: Logging out...")
        DispatchQueue.main.async { [weak self] in
            
            self?.currentCustomer = nil
            self?.customer = nil // Clear the @Published customer object
            self?.errorMessage = nil
            self?.isLoading = false
        }
        
        UserDefaults.standard.removeObject(forKey: "customer")
        UserDefaults.standard.removeObject(forKey: "auth_token")
        print("AuthService: User defaults cleared.")
        
        cancellables.removeAll()
    }
    
    func setAddressAsDefault(
        customerId: String,
        addressId: String,
        type: ProfileViewModel.AddressType,
        completion: @escaping (Bool, String?) -> Void
    ) {
        var updateRequest: [String: Any] = [:]
        switch type {
        case .shipping:
            updateRequest["default_shipping_address_id"] = addressId
        case .billing:
            updateRequest["default_billing_address_id"] = addressId
        }

        guard let body = try? JSONSerialization.data(withJSONObject: updateRequest, options: []) else {
            completion(false, "Failed to encode default address update request")
            return
        }

        NetworkManager.shared.request(endpoint: "customers/\(customerId)", method: "POST", body: body, requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionResult in
                if case .failure(let error) = completionResult {
                    completion(false, "Failed to set default address: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (response: CustomerResponse) in
                guard let self = self else { return }
                self.customer = response.customer // Update the @Published customer property
                self.saveCustomerData(response.customer)
                print("AuthService: Default address set. Updated customer defaultShippingAddressId: \(response.customer.defaultShippingAddressId ?? "N/A"), defaultBillingAddressId: \(response.customer.defaultBillingAddressId ?? "N/A")")
                completion(true, nil)
            })
            .store(in: &cancellables)
    }

    private func saveCustomerData(_ customer: Customer) {
        if let encoded = try? JSONEncoder().encode(customer) {
            UserDefaults.standard.set(encoded, forKey: "customer")
        }
    }
}
