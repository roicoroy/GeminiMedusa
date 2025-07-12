import Foundation
import Combine

class RegionSelectionViewModel: ObservableObject {
    @Published var regions: [Region] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedRegion: Region?

    private var regionService: RegionService
    private var cancellables = Set<AnyCancellable>()

    init(regionService: RegionService) {
        self.regionService = regionService
        setupBindings()
    }

    private func setupBindings() {
        regionService.$regions
            .assign(to: \.regions, on: self)
            .store(in: &cancellables)
        
        regionService.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        regionService.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        regionService.$selectedCountry
            .sink { [weak self] country in
                if let country = country {
                    self?.selectedRegion = self?.regions.first(where: { $0.id == country.regionId })
                } else {
                    self?.selectedRegion = nil
                }
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                // In a real app, you might re-fetch or re-filter based on search text
                // For now, filtering is done in filteredRegions computed property
            }
            .store(in: &cancellables)
    }

    func fetchRegions() {
        regionService.fetchRegions()
    }

    var filteredRegions: [Region] {
        guard !searchText.isEmpty else {
            return regions
        }
        return regions.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    func selectCountry(_ country: RegionService.CountrySelection) {
        regionService.selectCountry(country)
    }
}