//
//  RegionSelectionView.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import SwiftUI

struct RegionSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: RegionSelectionViewModel
    
    init(regionService: RegionService) {
        _viewModel = StateObject(wrappedValue: RegionSelectionViewModel(regionService: regionService))
    }
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView("Loading Regions...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.countries.isEmpty {
                    Text("No regions available.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.countries) { country in
                        Button(action: {
                            viewModel.selectCountry(country)
                            dismiss()
                        }) {
                            HStack {
                                Text(country.displayText)
                                Spacer()
                                if viewModel.isSelected(country: country) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Region")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if viewModel.countries.isEmpty {
                    viewModel.fetchRegions()
                }
            }
        }
    }
}

struct RegionSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RegionSelectionView(regionService: RegionService())
            .environmentObject(RegionService())
    }
}