import Foundation

public enum SelectableMeasurementSymbol: String, SingleSymbolProtocol, Codable {
    case equalTo = "equalTo"

    // MARK: static computed properties
    public static var singleSymbol: Self {
        return .equalTo
    }
}
