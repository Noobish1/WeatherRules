import CoreLocation
import Foundation

// Parts of https://github.com/braindrizzlestudio/BDAstroCalc
public enum SunCalculator {
    /// The obliquity of Earth
    private static let obliquityOfEarth = rad * 23.4397

    /// Multiplier for conversion from degrees to radians
    private static let rad = Double.pi / 180

    /// The number of Julian days at January 1, 2000.
    private static let J2000 = 2451545.0

    // MARK: - Date/Time Calculations
    private static func daysSinceJan12000(date: Date) -> Double {
        return toJulian(date: date) - J2000
    }

    private static func toJulian(date: Date) -> Double {
        let daySeconds = 24.hours
        let julian1970 = 2440588.0

        return date.timeIntervalSince1970 / daySeconds - 0.5 + julian1970
    }

    private static func altitude(hourAngle: Double, latitude: Double, declination: Double) -> Double {
        return asin(sin(latitude) * sin(declination) + cos(latitude) * cos(declination) * cos(hourAngle))
    }

    private static func declination(latitude: Double, longitude: Double) -> Double {
        return asin(sin(latitude) * cos(obliquityOfEarth) + cos(latitude) * sin(obliquityOfEarth) * sin(longitude))
    }

    private static func rightAscension(latitude: Double, longitude: Double) -> Double {
        return atan2(sin(longitude) * cos(obliquityOfEarth) - tan(latitude) * sin(obliquityOfEarth), cos(longitude))
    }

    private static func siderealTime(daysSinceJan12000: Double, longitude: Double) -> Double {
        return rad * (280.16 + 360.9856235 * daysSinceJan12000) - longitude
    }

    private static func eclipticLongitude(daysSinceJan12000: Double) -> Double {
        let meanAnomaly = solarMeanAnomaly(daysSinceJan12000: daysSinceJan12000)

        // Equation of Center
        let center = rad * (1.9148 * sin(meanAnomaly) + 0.02 * sin(2 * meanAnomaly) + 0.0003 * sin(3 * meanAnomaly))

        // Perihelion of Earth
        let perihelion = rad * 102.9372

        return meanAnomaly + center + perihelion + .pi
    }

    private static func solarMeanAnomaly(daysSinceJan12000: Double) -> Double {
        return rad * (357.5291 + 0.98560028 * daysSinceJan12000)
    }

    private static func hourAngle(daysSinceJan12000: Double, longitude: Double, rightAscension: Double) -> Double {
        return siderealTime(daysSinceJan12000: daysSinceJan12000, longitude: longitude) - rightAscension
    }

    public static func sunAltitude(date: Date, location: CLLocationCoordinate2D) -> CGFloat {
        let longitude = rad * -location.longitude
        let latitude = rad * location.latitude
        let days = daysSinceJan12000(date: date)
        let eLongitude = eclipticLongitude(daysSinceJan12000: days)
        let rightAscensionValue = rightAscension(latitude: 0, longitude: eLongitude)
        let declinationValue = declination(latitude: 0, longitude: eLongitude)
        let hourAngleValue = hourAngle(daysSinceJan12000: days, longitude: longitude, rightAscension: rightAscensionValue)

        let sunAltitude = altitude(hourAngle: hourAngleValue, latitude: latitude, declination: declinationValue)

        // Convert to degrees and clamp because for some reason we can get values outside it
        return (CGFloat(sunAltitude * 180) / CGFloat.pi).clamped(to: 0...90)
    }
}
