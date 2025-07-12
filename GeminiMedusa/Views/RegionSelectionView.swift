
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
                } else if viewModel.regions.isEmpty {
                    Text("No regions available.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.regions) { region in
                        Button(action: {
                            viewModel.selectCountry(CountrySelection(
                                country: region.countries?.first?.iso2 ?? "",
                                label: region.name,
                                currencyCode: region.currencyCode,
                                regionId: region.id
                            ))
                            dismiss()
                        }) {
                            HStack {
                                Text(region.name)
                                Spacer()
                                if viewModel.selectedRegion?.id == region.id {
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
                if viewModel.regions.isEmpty {
                    viewModel.fetchRegions()
                }
            }
            .onChange(of: viewModel.selectedRegion?.id) { newRegionId in
                // Handle region change if needed
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
