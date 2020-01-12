import Foundation

public final class Singular {
    // MARK: properties
    private var isDone = false

    // MARK: init/deinit
    public init() {}

    // MARK: performing tasks
    public func performOnce(operation: () -> Void) {
        guard !isDone else { return }
        isDone = true

        operation()
    }
}
