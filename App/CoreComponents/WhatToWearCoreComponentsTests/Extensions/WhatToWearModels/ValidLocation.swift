import Foundation
import CoreLocation
import WhatToWearModels

extension ValidLocation {
    internal static func random() -> ValidLocation {
        return ValidLocation(location: CLLocation.wtw.random())
    }
}
