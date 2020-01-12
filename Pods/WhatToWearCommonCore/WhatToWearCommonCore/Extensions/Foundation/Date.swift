import Foundation

extension Date {
    public enum wtw {
        public static func random() -> Date {
            return Date(timeIntervalSince1970: Double.random(in: 0..<Double.greatestFiniteMagnitude))
        }
    }
}
