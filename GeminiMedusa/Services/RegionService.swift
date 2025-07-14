import Foundation
import Combine


class RegionService: ObservableObject {
    @Published var regions: [Region] = []
    @Published var countryList: [CountrySelection] = []
    @Published var selectedCountry: CountrySelection?
    @Published var selectedRegion: Region? // Now a stored property

    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let defaultCountryCode = "gb" // Default to UK
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSelectionFromStorage()
        if selectedCountry == nil || selectedRegion == nil {
            fetchRegions()
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Region Management
    
    func fetchRegions() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.request(endpoint: "regions")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Failed to fetch regions: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] (response: RegionsResponse) in
                    guard let self = self else { return }
                    self.regions = response.regions
                    self.processCountries(from: response.regions)
                    self.setDefaultCountryIfNeeded()
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Country Processing (following the example pattern)
    
    private func processCountries(from regions: [Region]) {
        let newCountryList: [CountrySelection] = regions.compactMap { region in
            return region.countries?.map { country in
                CountrySelection(
                    country: country.iso2,
                    label: country.displayName,
                    currencyCode: region.currencyCode,
                    regionId: region.id
                )
            }
        }.flatMap { $0 }
        .sorted { $0.label.localizedCompare($1.label) == .orderedAscending }
        
        DispatchQueue.main.async { [weak self] in
            self?.countryList = newCountryList
            self?.setDefaultCountryIfNeeded()
        }
    }
    
    private func setDefaultCountryIfNeeded() {
        guard selectedCountry == nil else { return }

        if let defaultCountry = countryList.first(where: { $0.country.lowercased() == defaultCountryCode }) {
            selectCountry(defaultCountry)
            return
        }

        if let firstCountry = countryList.first {
            selectCountry(firstCountry)
        }
    }

    func selectCountry(_ country: CountrySelection) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedCountry = country
            self?.selectedRegion = self?.regions.first { $0.id == country.regionId }
            self?.saveSelectionToStorage()
        }
    }

    func selectRegion(_ region: Region) {
        if let firstCountry = region.toCountrySelections().first {
            selectCountry(firstCountry)
        }
    }

    // MARK: - Storage

    private func saveSelectionToStorage() {
        if let encodedCountry = try? JSONEncoder().encode(selectedCountry) {
            UserDefaults.standard.set(encodedCountry, forKey: "medusa_country")
        }
        if let encodedRegion = try? JSONEncoder().encode(selectedRegion) {
            UserDefaults.standard.set(encodedRegion, forKey: "medusa_region")
        }
    }

    private func loadSelectionFromStorage() {
        if let countryData = UserDefaults.standard.data(forKey: "medusa_country"),
           let country = try? JSONDecoder().decode(CountrySelection.self, from: countryData) {
            selectedCountry = country
        }

        if let regionData = UserDefaults.standard.data(forKey: "medusa_region"),
           let region = try? JSONDecoder().decode(Region.self, from: regionData) {
            selectedRegion = region
        }
    }

    // MARK: - Utility Methods

    func refreshRegions() {
        fetchRegions()
    }

    var hasSelectedRegion: Bool {
        return selectedCountry != nil
    }

    var selectedRegionId: String? {
        return selectedCountry?.regionId
    }

    var selectedRegionCurrency: String? {
        return selectedCountry?.currencyCode
    }

    func clearSelection() {
        selectedCountry = nil
        selectedRegion = nil
        UserDefaults.standard.removeObject(forKey: "medusa_country")
        UserDefaults.standard.removeObject(forKey: "medusa_region")
    }

    // MARK: - Country-specific helpers

    func getCountriesForSelectedRegion() -> [Country] {
        guard let selectedRegion = selectedRegion else { return [] }
        return selectedRegion.countries ?? []
    }

    func hasUKInSelectedRegion() -> Bool {
        return selectedCountry?.country.lowercased() == "gb"
    }
}