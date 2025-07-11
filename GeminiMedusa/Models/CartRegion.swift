import Foundation

public struct CartRegion: Codable, Identifiable {
    public let id: String
    public let name: String
    public let currencyCode: String
    public let automaticTaxes: Bool
    public let countries: [CartCountry]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, countries
        case currencyCode = "currency_code"
        case automaticTaxes = "automatic_taxes"
    }
}

public struct CartCountry: Codable, Identifiable {
    public let iso2: String
    public let iso3: String
    public let numCode: String
    public let name: String
    public let displayName: String
    public let regionId: String
    public let metadata: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let deletedAt: String?
    
    public var id: String { iso2 }
    
    enum CodingKeys: String, CodingKey {
        case name, metadata
        case iso2 = "iso_2"
        case iso3 = "iso_3"
        case numCode = "num_code"
        case displayName = "display_name"
        case regionId = "region_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}