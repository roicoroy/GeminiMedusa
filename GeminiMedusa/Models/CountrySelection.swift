import Foundation

public struct CountrySelection: Codable, Identifiable, Equatable {
    public let country: String        // iso2 code (e.g., "gb", "fr")
    public let label: String          // display name (e.g., "United Kingdom")
    public let currencyCode: String   // currency (e.g., "eur")
    public let regionId: String       // region ID for cart creation
    
    public var id: String { country } // Use country code as identifier
    
    // MARK: - Equatable Conformance
    public static func == (lhs: CountrySelection, rhs: CountrySelection) -> Bool {
        return lhs.country == rhs.country &&
               lhs.regionId == rhs.regionId &&
               lhs.currencyCode == rhs.currencyCode
    }
    
    // Computed properties for display
    public var flagEmoji: String {
        let iso = country.lowercased()
        
        switch iso {
        case "gb": return "🇬🇧"
        case "us": return "🇺🇸"
        case "ca": return "🇨🇦"
        case "de": return "🇩🇪"
        case "fr": return "🇫🇷"
        case "es": return "🇪🇸"
        case "it": return "🇮🇹"
        case "dk": return "🇩🇰"
        case "se": return "🇸🇪"
        case "au": return "🇦🇺"
        case "jp": return "🇯🇵"
        case "br": return "🇧🇷"
        default: return "🏳️"
        }
    }
    
    public var formattedCurrency: String {
        return currencyCode.uppercased()
    }
    
    public var displayText: String {
        return "\(flagEmoji) \(label)"
    }
}