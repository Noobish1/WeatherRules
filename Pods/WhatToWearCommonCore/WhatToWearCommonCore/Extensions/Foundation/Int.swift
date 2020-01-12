import Foundation

extension Int: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> Int {
            return Int.random(in: Int.min...Int.max)
        }
    }
}
