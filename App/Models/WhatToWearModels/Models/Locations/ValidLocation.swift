import CoreLocation
import Foundation
import MapKit

// MARK: ValidLocation
public struct ValidLocation: Codable {
    // MARK: properties
    public let address: String?
    public let coordinate: CLLocationCoordinate2D

    // MARK: init from MKMapItem
    public init?(mapItem: MKMapItem) {
        guard let formattedAddressLines = mapItem.placemark.addressDictionary?["FormattedAddressLines"] as? [String] else {
            return nil
        }

        self.address = formattedAddressLines.joined(separator: ", ")
        self.coordinate = mapItem.placemark.coordinate
    }

    // MARK: init from CLPLacemark
    public init?(placemark: CLPlacemark) {
        guard let location = placemark.location else {
            return nil
        }

        guard let formattedAddressLines = placemark.addressDictionary?["FormattedAddressLines"] as? [String] else {
            return nil
        }

        self.address = formattedAddressLines.joined(separator: ", ")
        self.coordinate = location.coordinate
    }

    // MARK: init from coordinate
    public init(location: CLLocation) {
        self.address = nil
        self.coordinate = location.coordinate
    }
}

// MARK: Hashable
extension ValidLocation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(address)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}

// MARK: Equatable
extension ValidLocation: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // We're looking for exact matches
        return  lhs.address == rhs.address &&
                abs(lhs.coordinate.latitude - rhs.coordinate.latitude) < Double.ulpOfOne &&
                abs(lhs.coordinate.longitude - rhs.coordinate.longitude) < Double.ulpOfOne
    }
}
