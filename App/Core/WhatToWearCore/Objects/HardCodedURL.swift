import Foundation

public struct HardCodedURL {
    // MARK: properties
    public let url: URL

    // MARK: computed property
    public var analyticsValue: String {
        return url.absoluteString
    }

    // MARK: init
    public init(_ urlString: String) {
        guard let safeURL = URL(string: urlString) else {
            fatalError("urlString \(urlString) could not be turned into a URL")
        }

        self.url = safeURL
    }
}
