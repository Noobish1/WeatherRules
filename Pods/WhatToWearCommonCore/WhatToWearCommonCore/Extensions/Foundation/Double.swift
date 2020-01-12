import Foundation

extension Double: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> Double {
            return Double.random(in: Double.leastNormalMagnitude...Double.greatestFiniteMagnitude)
        }
    }
}
