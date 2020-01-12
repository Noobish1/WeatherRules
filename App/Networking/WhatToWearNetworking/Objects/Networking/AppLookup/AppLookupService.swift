import CoreLocation
import Foundation
import Moya
import WhatToWearAssets
import WhatToWearEnvironment
import WhatToWearModels

internal enum AppLookupService {
    case lookup
}

extension AppLookupService: TargetType {
    internal var baseURL: URL {
        return Environment.Variables.AppLookupBaseURL.url
    }

    internal var path: String {
        switch self {
            case .lookup: return "lookup"
        }
    }

    internal var method: Moya.Method {
        switch self {
            case .lookup: return .get
        }
    }

    internal var sampleData: Data {
        switch self {
            case .lookup:
                guard
                    let url = R.file.applookupJson(), let data = try? Data(contentsOf: url)
                else {
                    return Data()
                }

                return data
        }
    }

    internal var task: Task {
        switch self {
            case .lookup:
                let parameters = AppLookupParameters(
                    appID: Environment.Variables.AppID
                ).toDictionary(forHTTPMethod: .get)

                return .requestParameters(parameters: parameters, encoding: URLEncoding())
        }
    }

    internal var validationType: ValidationType {
        switch self {
            case .lookup: return .successCodes
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
