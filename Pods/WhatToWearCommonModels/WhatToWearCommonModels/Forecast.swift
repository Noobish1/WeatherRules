import CoreLocation
import Foundation
import WhatToWearCommonCore

// MARK: Forecast
public struct Forecast {
    // MARK: properties
    internal let latitude: Double
    internal let longitude: Double
    public let timeZone: TimeZone
    public let hourly: HourlyForecast
    public let daily: DailyForecast

    // MARK: computed properties
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: Equatable
extension Forecast: Equatable {}

// MARK: ContainerCodable
extension Forecast: ContainerCodable {
    internal enum DecodingError: Error {
        case invalidTimeZone
    }

    public enum CodingKeys: String, ContainerCodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case timeZone = "timezone"
        case hourly = "hourly"
        case daily = "daily"
    }

    // MARK: ContainerDecodable
    public init(from container: KeyedDecodingContainer<CodingKeys>) throws {
        let timeZoneIdentifier = try container.decode(String.self, forKey: .timeZone)

        guard let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
            throw DecodingError.invalidTimeZone
        }

        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.timeZone = timeZone
        self.hourly = try container.decode(HourlyForecast.self, forKey: .hourly)
        self.daily = try container.decode(DailyForecast.self, forKey: .daily)
    }

    // MARK: ContainerEncodable
    public func encodeValue(
        forKey key: CodingKeys,
        in container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        switch key {
            case .latitude: try container.encode(latitude, forKey: key)
            case .longitude: try container.encode(longitude, forKey: key)
            case .timeZone: try container.encode(timeZone.identifier, forKey: key)
            case .hourly: try container.encode(hourly, forKey: key)
            case .daily: try container.encode(daily, forKey: key)
        }
    }
}
