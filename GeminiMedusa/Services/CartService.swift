import Foundation
import Combine


class CartService: ObservableObject {
    @Published var currentCart: Cart?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadCartFromStorage()
    }

    deinit {
        cancellables.removeAll()
    }

    func createCart(regionId: String, completion: @escaping (Bool) -> Void = { _ in }) {
        isLoading = true
        errorMessage = nil

        let request = CreateCartRequest(regionId: regionId)
        guard let body = try? JSONEncoder().encode(request) else {
            errorMessage = "Failed to encode cart request"
            isLoading = false
            completion(false)
            return
        }

        NetworkManager.shared.request(endpoint: "carts", method: "POST", body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                if case .failure(let error) = completionResult {
                    self?.errorMessage = "Failed to create cart: \(error.localizedDescription)"
                    completion(false)
                }
            }, receiveValue: { [weak self] (response: CartResponse) in
                self?.currentCart = response.cart
                self?.saveCartToStorage()
                self?.objectWillChange.send()
                self?.fetchCart(cartId: response.cart.id) // Re-fetch cart to ensure latest state
                completion(true)
            })
            .store(in: &cancellables)
    }

    func addLineItem(variantId: String, quantity: Int = 1, regionId: String, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let cart = currentCart else {
            createCart(regionId: regionId) { [weak self] success in
                if success {
                    self?.addLineItem(variantId: variantId, quantity: quantity, regionId: regionId, completion: completion)
                } else {
                    completion(false)
                }
            }
            return
        }

        isLoading = true
        errorMessage = nil

        let request = AddLineItemRequest(variantId: variantId, quantity: quantity)
        guard let body = try? JSONEncoder().encode(request) else {
            completion(false)
            return
        }

        NetworkManager.shared.request(endpoint: "carts/\(cart.id)/line-items", method: "POST", body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                if case .failure(let error) = completionResult {
                    self?.errorMessage = "Failed to add item to cart: \(error.localizedDescription)"
                    completion(false)
                }
            }, receiveValue: { [weak self] (response: CartResponse) in
                self?.currentCart = response.cart
                self?.saveCartToStorage()
                self?.objectWillChange.send()
                self?.fetchCart(cartId: response.cart.id) // Re-fetch cart to ensure latest state
                completion(true)
            })
            .store(in: &cancellables)
    }

    func removeLineItem(lineItemId: String, onComplete: @escaping (Bool) -> Void = { _ in }) {
        guard let cart = currentCart else {
            onComplete(false)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.requestData(endpoint: "carts/\(cart.id)/line-items/\(lineItemId)", method: "DELETE", requiresAuth: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                if case .failure(let error) = completionResult {
                    self?.errorMessage = "Failed to remove item: \(error.localizedDescription)"
                    onComplete(false)
                }
            }, receiveValue: { [weak self] (data: Data) in
                self?.handleRemoveLineItemResponse(data: data, onComplete: onComplete)
            })
            .store(in: &cancellables)
    }

    private func handleRemoveLineItemResponse(data: Data, onComplete: @escaping (Bool) -> Void) {
        do {
            let response = try JSONDecoder().decode(CartResponse.self, from: data)
            self.currentCart = response.cart
            self.saveCartToStorage()
            onComplete(true)
            return
        } catch {}
        
        if let cart = currentCart {
            fetchCart(cartId: cart.id)
        }
        onComplete(true)
    }
    
    func fetchCart(cartId: String) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(endpoint: "carts/\(cartId)")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                if case .failure(let error) = completionResult {
                    self?.errorMessage = "Failed to fetch cart: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] (response: CartResponse) in
                self?.currentCart = response.cart
                self?.saveCartToStorage()
                self?.objectWillChange.send()
                print("DEBUG: Fetched cart: \(response.cart)")
            })
            .store(in: &cancellables)
    }

    func clearCart() {
        currentCart = nil
        UserDefaults.standard.removeObject(forKey: "medusa_cart")
        objectWillChange.send()
    }

    private func saveCartToStorage() {
        if let encoded = try? JSONEncoder().encode(currentCart) {
            UserDefaults.standard.set(encoded, forKey: "medusa_cart")
        }
    }

    private func loadCartFromStorage() {
        if let cartData = UserDefaults.standard.data(forKey: "medusa_cart"),
           let cart = try? JSONDecoder().decode(Cart.self, from: cartData) {
            currentCart = cart
        }
    }
}


