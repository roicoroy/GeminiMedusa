import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var isShowingEditProfileSheet: Bool

    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String

    init(viewModel: ProfileViewModel, isShowingEditProfileSheet: Binding<Bool>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _isShowingEditProfileSheet = isShowingEditProfileSheet
        _firstName = State(initialValue: viewModel.customer?.firstName ?? "")
        _lastName = State(initialValue: viewModel.customer?.lastName ?? "")
        _email = State(initialValue: viewModel.customer?.email ?? "")
        _phone = State(initialValue: viewModel.customer?.phone ?? "")
        
        print("EditProfileView Init - First Name: \(firstName), Last Name: \(lastName), Email: \(email), Phone: \(phone)")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Personal Details")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }

                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.updateCustomer(firstName: firstName, lastName: lastName, email: email, phone: phone)
                    isShowingEditProfileSheet = false
                }) {
                    Text("Save Changes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(leading: Button("Cancel") {
                isShowingEditProfileSheet = false
            })
        }
    }
}
