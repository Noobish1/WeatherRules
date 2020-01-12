import Foundation
import WhatToWearCommonCore

// MARK: General extensions
extension OperatingSystemVersion {
    // MARK: short string version
    public var shortStringRepresentation: String {
        return "\(majorVersion).\(minorVersion).\(patchVersion)"
    }
    
    // MARK: simpler init
    public init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.init(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }

    // This will break if the version isn't in the form Int.Int.Int
    public static func from(string: String) -> OperatingSystemVersion {
        let parts: [Int] = string.split(separator: ".").map { part in
            guard let integerValue = Int(part) else {
                fatalError("Incorrect OperatingSystemVersion part: \(part)")
            }
            
            return integerValue
        }
            
        guard !parts.isEmpty else {
            fatalError("OperatingSystemVersion must have at least one digit")
        }
            
        let finalParts = parts.byPadding(with: 0, upTo: 3)

        return OperatingSystemVersion(finalParts[0], finalParts[1], finalParts[2])
    }
}

// MARK: ExpressibleByStringLiteral
// We need this so that WhatsNewVersion can have OperatingSystemVersion as its rawValue
extension OperatingSystemVersion: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self = OperatingSystemVersion.from(string: value)
    }
}

// MARK: Equatable
extension OperatingSystemVersion: Equatable {
    public static func == (lhs: OperatingSystemVersion, rhs: OperatingSystemVersion) -> Bool {
        return  lhs.majorVersion == rhs.majorVersion &&
                lhs.minorVersion == rhs.minorVersion &&
                lhs.patchVersion == rhs.patchVersion
    }
}

// MARK: Comparable
extension OperatingSystemVersion: Comparable {
    public static func < (lhs: OperatingSystemVersion, rhs: OperatingSystemVersion) -> Bool {
        return (lhs.majorVersion, lhs.minorVersion, lhs.patchVersion) < (rhs.majorVersion, rhs.minorVersion, rhs.patchVersion)
    }
}

// MARK: WTWRandomized
extension OperatingSystemVersion: WTWRandomized {
    // swiftlint:disable type_name
    public enum wtw: WTWRandomizer {
    // swiftlint:enable type_name
        public static func random() -> OperatingSystemVersion {
            return OperatingSystemVersion(
                majorVersion: Int.wtw.random(),
                minorVersion: Int.wtw.random(),
                patchVersion: Int.wtw.random()
            )
        }
    }
}

// MARK: Codable
extension OperatingSystemVersion: Codable {
    public enum CodingKeys: String, CodingKey {
        case majorVersion = "majorVersion"
        case minorVersion = "minorVersion"
        case patchVersion = "patchVersion"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(
            majorVersion: try container.decode(Int.self, forKey: .majorVersion),
            minorVersion: try container.decode(Int.self, forKey: .minorVersion),
            patchVersion: try container.decode(Int.self, forKey: .patchVersion)
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(majorVersion, forKey: .majorVersion)
        try container.encode(minorVersion, forKey: .minorVersion)
        try container.encode(patchVersion, forKey: .patchVersion)
    }
}
