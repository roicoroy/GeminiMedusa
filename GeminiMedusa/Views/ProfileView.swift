import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var authService: AuthService
    @State private var showingEditProfileSheet = false
    @State private var showingAddAddressSheet = false

    var body: some View {
        NavigationView {
            List {
                ProfileDetailsSection(viewModel: viewModel)
                ProfileAddressesSection(viewModel: viewModel, showingAddAddressSheet: $showingAddAddressSheet)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit Profile") {
                        showingEditProfileSheet = true
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        authService.logout()
                    }
                }
            }
            .sheet(isPresented: $showingEditProfileSheet) {
                EditProfileView(viewModel: viewModel, isShowingEditProfileSheet: $showingEditProfileSheet)
            }
            .sheet(isPresented: $showingAddAddressSheet) {
                EditAddressView(viewModel: viewModel, isShowingEditAddressSheet: $showingAddAddressSheet)
            }
            .onAppear(perform: viewModel.fetchCustomerProfile)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthService())
    }
}

