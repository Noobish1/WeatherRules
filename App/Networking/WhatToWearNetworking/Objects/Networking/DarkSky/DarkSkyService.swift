import CoreLocation
import Foundation
import Moya
import WhatToWearAssets
import WhatToWearEnvironment
import WhatToWearModels

internal enum DarkSkyService {
    case forecast(date: Date, location: ValidLocation)
}

extension DarkSkyService: TargetType {
    internal var baseURL: URL {
        return Environment.Variables.DarkSkyBaseURL.url
    }

    internal var path: String {
        switch self {
            case .forecast(date: let date, location: let location):
                return "forecast/\(Environment.Variables.DarkSkyAPIKey)/\(location.coordinate.latitude),\(location.coordinate.longitude),\(Int(date.timeIntervalSince1970))"
        }
    }

    internal var method: Moya.Method {
        switch self {
            case .forecast: return .get
        }
    }

    internal var sampleData: Data {
        switch self {
            case .forecast:
                guard
                    let url = R.file.forecastJson(), let data = try? Data(contentsOf: url)
                else {
                    return Data()
                }

                return data
        }
    }

    internal var task: Task {
        switch self {
            case .forecast:
                let parameters = ForecastParameters().toDictionary(forHTTPMethod: .get)

                return .requestParameters(parameters: parameters, encoding: URLEncoding())
        }
    }

    internal var validationType: ValidationType {
        switch self {
            case .forecast: return .successCodes
        }
    }

    // swiftlint:disable discouraged_optional_collection
    internal var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "Accept": "application/json",
            "Accept-Encoding": "gzip"
        ]
    }
    // swiftlint:enable discouraged_optional_collection
}
