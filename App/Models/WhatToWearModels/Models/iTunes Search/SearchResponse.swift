import Foundation

public struct SearchResponse: Codable {
    internal let results: [LatestAppUpdate]
}

extension SearchResponse {
    public var latestAppUpdate: LatestAppUpdate? {
        return results.first
    }
}
