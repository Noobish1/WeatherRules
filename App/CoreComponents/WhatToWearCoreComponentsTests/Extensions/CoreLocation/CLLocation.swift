import CoreLocation

extension CLLocation {
    internal enum wtw {
        internal static func random() -> CLLocation {
            return CLLocation(
                latitude: CLLocationDegrees.random(in: 0...90),
                longitude: CLLocationDegrees.random(in: -180...180)
            )
        }
    }
}
