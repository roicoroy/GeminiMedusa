import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = "test2@email.com"
    @Published var password = "Rwbento123!"
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isLoggedIn = false

    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthService = AuthService()) {
        self.authService = authService
        setupBindings()
    }

    private func setupBindings() {
        authService.$customer
            .map { $0 != nil }
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &cancellables)
    }

    func login() {
        isLoading = true
        errorMessage = nil

        authService.authenticate(email: email, password: password)
    }
}
