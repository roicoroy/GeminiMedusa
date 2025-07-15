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
        loadSelectionFromStorage() // Load saved selection immediately
        fetchRegions() // Then fetch regions from network
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
                    
                    // Only set default if no region was loaded from storage
                    if self.selectedCountry == nil {
                        self.setDefaultCountryIfNeeded()
                    }
                    
                    // Ensure a default currency is set if none is selected
                    if self.selectedRegionCurrency == nil {
                        self.selectedCountry = self.countryList.first(where: { $0.currencyCode == "usd" }) ?? self.countryList.first
                    }
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
        
        DispatchQueue.main.async {
            self.countryList = newCountryList
            // No need to call setDefaultCountryIfNeeded here, it's handled in fetchRegions
        }
    }
    
    private func setDefaultCountryIfNeeded() {
        guard selectedCountry == nil else { return }
        print("RegionService: Setting default country because selectedCountry is nil.")

        if let defaultCountry = countryList.first(where: { $0.country.lowercased() == defaultCountryCode }) {
            selectCountry(defaultCountry)
            print("RegionService: Default country set to: \(defaultCountry.label)")
            return
        }

        if let firstCountry = countryList.first {
            selectCountry(firstCountry)
            print("RegionService: First country set as default: \(firstCountry.label)")
        } else {
            print("RegionService: No countries available to set as default.")
        }
    }

    func selectCountry(_ country: CountrySelection) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedCountry = country
            self?.selectedRegion = self?.regions.first { $0.id == country.regionId }
            self?.saveSelectionToStorage()
            print("RegionService: Selected country: \(country.label), Region: \(self?.selectedRegion?.name ?? "N/A")")
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
            print("RegionService: Saved selectedCountry to UserDefaults.")
        }
        if let encodedRegion = try? JSONEncoder().encode(selectedRegion) {
            UserDefaults.standard.set(encodedRegion, forKey: "medusa_region")
            print("RegionService: Saved selectedRegion to UserDefaults.")
        }
    }

    private func loadSelectionFromStorage() {
        print("RegionService: Attempting to load selection from storage.")
        if let countryData = UserDefaults.standard.data(forKey: "medusa_country"),
           let country = try? JSONDecoder().decode(CountrySelection.self, from: countryData) {
            selectedCountry = country
            print("RegionService: Loaded selectedCountry: \(country.label)")
        } else {
            print("RegionService: No country data found or failed to decode from storage.")
        }

        if let regionData = UserDefaults.standard.data(forKey: "medusa_region"),
           let region = try? JSONDecoder().decode(Region.self, from: regionData) {
            selectedRegion = region
            print("RegionService: Loaded selectedRegion: \(region.name ?? "N/A")")
        } else {
            print("RegionService: No region data found or failed to decode from storage.")
        }
    }