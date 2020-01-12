import UIKit

open class CodeBackedCell: UITableViewCell {
    // MARK: init
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    // MARK: setup
    open func setupViews() {
        // subclasses can override this to setup their subviews
    }
}
