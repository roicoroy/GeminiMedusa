import Foundation
import Combine

class AuthenticationWatcherService: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        // Initial check
        checkTokenStatus()
    }

    func checkTokenStatus() {
        DispatchQueue.main.async {
            self.isLoggedIn = UserDefaults.standard.string(forKey: "auth_token") != nil
            print("AuthenticationWatcherService: Token status checked. isLoggedIn: \(self.isLoggedIn)")
        }
    }
}
