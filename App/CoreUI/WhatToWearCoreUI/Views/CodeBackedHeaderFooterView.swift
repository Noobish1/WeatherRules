import Foundation

open class CodeBackedHeaderFooterView: UITableViewHeaderFooterView {
    // MARK: init
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: setup
    open func setupViews() {
        // subclasses can override to setup subviews
    }
}
