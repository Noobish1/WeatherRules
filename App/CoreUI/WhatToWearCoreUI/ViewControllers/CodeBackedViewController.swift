import Foundation

open class CodeBackedViewController: UIViewController {
    // MARK: init
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
}
