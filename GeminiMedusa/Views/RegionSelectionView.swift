
//
//  RegionSelectionView.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import SwiftUI

struct RegionSelectionView: View {
    @EnvironmentObject var regionService: RegionService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if regionService.isLoading {
                    ProgressView("Loading Regions...")
                } else if let errorMessage = regionService.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if regionService.countryList.isEmpty {
                    Text("No regions available.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(regionService.countryList) { country in
                        Button(action: {
                            regionService.selectCountry(country)
                            dismiss()
                        }) {
                            HStack {
                                Text(country.displayText)
                                Spacer()
                                if regionService.selectedCountry?.id == country.id {
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
                if regionService.regions.isEmpty {
                    regionService.fetchRegions()
                }
            }
        }
    }
}

struct RegionSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RegionSelectionView()
            .environmentObject(RegionService())
    }
}
