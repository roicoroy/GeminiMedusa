import SwiftUI

struct ProfileDetailsSection: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        Section(header: Text("Customer Details")) {
            HStack {
                Text("Name:")
                Spacer()
                Text("\(viewModel.customer?.firstName ?? "") \(viewModel.customer?.lastName ?? "")")
            }
            HStack {
                Text("Email:")
                Spacer()
                Text(viewModel.customer?.email ?? "N/A")
            }
            HStack {
                Text("Phone:")
                Spacer()
                Text(viewModel.customer?.phone ?? "N/A")
            }
        }
    }
}