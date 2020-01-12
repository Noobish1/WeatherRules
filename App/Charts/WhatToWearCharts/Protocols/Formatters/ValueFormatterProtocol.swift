import Foundation

public protocol ValueFormatterProtocol: AnyObject {
    func string(for entry: CGPoint) -> String
}
