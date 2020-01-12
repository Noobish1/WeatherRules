import Foundation

extension Float: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> Float {
            return Float.random(in: Float.leastNormalMagnitude...Float.greatestFiniteMagnitude)
        }
    }
}
