import Foundation
import WhatToWearCommonCore

// MARK: WindDirection
public enum WindDirection: String, Codable, CaseIterable {
    case north = "north"
    case south = "south"
    case east = "east"
    case west = "west"
    case northEast = "northEast"
    case northWest = "northWest"
    case southEast = "southEast"
    case southWest = "southWest"

    // MARK: computed properties
    private var ranges: [ClosedRange<Double>] {
        // 360 degrees, divided by 8 directions, divided by 2 sides (of its numerical center value)
        let halfSection: Double = (360 / 8) / 2

        guard self != .north else {
            return [(360 - halfSection...360), (self.numericalValue...halfSection)]
        }

        return [(self.numericalValue - halfSection)...(self.numericalValue + halfSection)]
    }

    public var numericalValue: Double {
        switch self {
            case .north: return 0
            case .south: return 180
            case .east: return 90
            case .west: return 270
            case .northEast: return 45
            case .northWest: return 315
            case .southEast: return 135
            case .southWest: return 225
        }
    }

    // MARK: init
    public init?(windBearing: Double?) {
        guard let bearing = windBearing else {
            return nil
        }

        for direction in Self.allCases {
            if direction.ranges.any({ $0.contains(bearing) }) {
                self = direction

                return
            }
        }

        return nil
    }
}
