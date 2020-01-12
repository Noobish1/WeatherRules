import CommonCrypto
import Foundation

// MARK: Static strings
extension String {
    public static let nbsp = "\u{00a0}"
    public static let nbhypen = "\u{02011}"
}

// MARK: General extensions
extension String {
    public func md5HexString() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let stringData = data(using: String.Encoding.utf8) {
            _ = stringData.withUnsafeBytes { body in
                CC_MD5(body.baseAddress, CC_LONG(stringData.count), &digest)
            }
        }
        
        return digest.reduce(into: "") { string, next in
            string.append(String(format: "%02x", next))
        }
    }
}
