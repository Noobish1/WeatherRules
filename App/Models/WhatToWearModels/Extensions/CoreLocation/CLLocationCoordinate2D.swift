import CoreLocation
import WhatToWearCommonCore
import WhatToWearCore

extension CLLocationCoordinate2D: ContainerCodable {
    public enum CodingKeys: String, ContainerCodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }

    // MARK: Decodable
    public init(from container: KeyedDecodingContainer<CodingKeys>) throws {
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)

        self.init(latitude: latitude, longitude: longitude)
    }

    // MARK: Encodable
    public func encodeValue(forKey key: CodingKeys, in container: inout KeyedEncodingContainer<CodingKeys>) throws {
        switch key {
            case .latitude: try container.encode(latitude, forKey: key)
            case .longitude: try container.encode(longitude, forKey: key)
        }
    }
}
