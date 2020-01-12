import Foundation

// MARK: Sequences of Strings
extension Sequence where Iterator.Element == String {
    public var oxfordCommaString: String {
        let words = Array(self)
        guard !words.isEmpty else {
            return ""
        }

        let count = words.count

        switch count {
            case 1:
                return words[0]
            case 2:
                let format = NSLocalizedString("%@ and %@", comment: "")

                return String(format: format, arguments: [words[0], words[1]])
            default:
                let pre: String = words[0..<(count - 1)].joined(
                    separator: NSLocalizedString(", ", comment: "")
                )
                let last = words[(count - 1)]
                let format = NSLocalizedString("%@, and %@", comment: "")

                return String(format: format, arguments: [pre, last])
        }
    }
}
