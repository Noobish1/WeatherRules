import ErrorRecorder
import Foundation
import SnapKit
import Then

public final class LoadingViewController<LoadedViewController: UIViewController>: CodeBackedViewController {
    // MARK: properties
    private let contentView: LoadingContentView

    // MARK: init/deinit
    public init(title: String = NSLocalizedString("Loading", comment: "")) {
        self.contentView = LoadingContentView(title: title)

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .clear

        view.add(subview: contentView, withConstraints: { make in
            make.center.equalToSuperview()
        })
    }

    public override func updateViewConstraints() {
        if let window = view.window {
            contentView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(window)
            }
        }

        super.updateViewConstraints()
    }

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentView.startAnimating()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .loading(forLoadedViewController: LoadedViewController.self))
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        contentView.stopAnimating()
    }

    // MARK: update
    public func update(title: String) {
        contentView.update(title: title)
    }
}
