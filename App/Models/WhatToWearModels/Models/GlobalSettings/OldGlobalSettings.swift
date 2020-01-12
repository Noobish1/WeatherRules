import Foundation
import WhatToWearCommonCore
import WhatToWearCore

// MARK: OldGlobalSettings
public struct OldGlobalSettings {
    public let measurementSystem: MeasurementSystem
    public let shownComponents: Set<WeatherChartComponent>

    public init(
        measurementSystem: MeasurementSystem,
        shownComponents: Set<WeatherChartComponent>
    ) {
        self.measurementSystem = measurementSystem
        self.shownComponents = shownComponents
    }
}

// We need this to be `ContainerCodable` because
// `Codable` doesn't work when decoding the stored version of this
// MARK: ContainerCodable
extension OldGlobalSettings: ContainerCodable {
    public enum CodingKeys: String, ContainerCodingKey {
        case measurementSystem = "measurementSystem"
        case shownMeasurements = "shownMeasurements"
    }

    // MARK: Decodable
    public init(from container: KeyedDecodingContainer<CodingKeys>) throws {
        let system = try container.decode(MeasurementSystem.self, forKey: .measurementSystem)
        let shownComponents = try container.decode(
            Set<WeatherChartComponent>.self,
            forKey: .shownMeasurements
        )

        self.init(measurementSystem: system, shownComponents: shownComponents)
    }

    // MARK: Encodable
    public func encodeValue(
        forKey key: CodingKeys,
        in container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        switch key {
            case .measurementSystem: try container.encode(measurementSystem, forKey: key)
            case .shownMeasurements: try container.encode(shownComponents, forKey: key)
        }
    }
}
