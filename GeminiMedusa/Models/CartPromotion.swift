import Foundation

public struct CartPromotion: Codable, Identifiable {
    public let id: String
    public let code: String?
    public let isAutomatic: Bool?
    public let applicationMethod: PromotionApplicationMethod?

    enum CodingKeys: String, CodingKey {
        case id, code
        case isAutomatic = "is_automatic"
        case applicationMethod = "application_method"
    }
}

public struct PromotionApplicationMethod: Codable {
    public let value: Int?
    public let type: String?
    public let currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case value, type
        case currencyCode = "currency_code"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode)
        value = try decodeFlexibleInt(from: container, forKey: .value)
    }
}
