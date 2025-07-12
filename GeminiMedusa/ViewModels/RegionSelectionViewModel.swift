import Foundation
import Combine

class RegionSelectionViewModel: ObservableObject {
    @Published var countries: [CountrySelection] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCountry: CountrySelection?

    private var regionService: RegionService
    private var cancellables = Set<AnyCancellable>()

    init(regionService: RegionService) {
        self.regionService = regionService
        setupBindings()
    }

    private func setupBindings() {
        regionService.$countryList
            .assign(to: \.countries, on: self)
            .store(in: &cancellables)
        
        regionService.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        regionService.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        regionService.$selectedCountry
            .assign(to: \.selectedCountry, on: self)
            .store(in: &cancellables)
    }

    func fetchRegions() {
        regionService.fetchRegions()
    }
    
    func selectCountry(_ country: CountrySelection) {
        regionService.selectCountry(country)
    }
    
    func isSelected(country: CountrySelection) -> Bool {
        return selectedCountry?.id == country.id
    }
}