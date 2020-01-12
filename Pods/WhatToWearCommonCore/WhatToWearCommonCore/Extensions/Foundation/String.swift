import Foundation

extension String: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> String {
            return Array(repeating: (), count: .random(in: 5...50))
                .map { String(UnicodeScalar(UInt8.random(in: 0...128))) }
                .joined()
        }
    }
}
