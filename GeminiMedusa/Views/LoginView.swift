import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var authService: AuthService
    @Binding var isShowingLogin: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Login")) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                }

                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.login()
                }) {
                    Text("Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)

                Section(header: Text("Debug Info")) {
                    if let customer = authService.customer {
                        Text("Customer ID: \(customer.id)")
                        Text("Customer Email: \(customer.email)")
                        if let token = UserDefaults.standard.string(forKey: "auth_token") {
                            Text("Auth Token Saved: Yes")
                        } else {
                            Text("Auth Token Saved: No")
                        }
                    } else {
                        Text("No customer data after login.")
                    }
                }
            }
            .navigationTitle("Login")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowingLogin = false
                    }
                }
            }
            .onChange(of: viewModel.isLoggedIn) { isLoggedIn in
                if isLoggedIn {
                    isShowingLogin = false
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isShowingLogin: .constant(true))
            .environmentObject(AuthService())
    }
}