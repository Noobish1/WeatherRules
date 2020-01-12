import ErrorRecorder
import NotificationCenter
import Then
import UIKit

public final class ErrorViewController: CodeBackedViewController {
    // MARK: properties
    private let label = UILabel().then {
        $0.text = NSLocalizedString("Forecast failed to load.\nTap to try again", comment: "")
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .white
    }
    private let loadedViewControllerType: UIViewController.Type
    private let onTap: () -> Void
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    private let onLoadComplete: ((NCUpdateResult) -> Void)?

    // MARK: init/deinit
    public init(
        loadedViewControllerType: UIViewController.Type,
        onTap: @escaping () -> Void,
        onLoadComplete: ((NCUpdateResult) -> Void)?
    ) {
        self.loadedViewControllerType = loadedViewControllerType
        self.onTap = onTap
        self.onLoadComplete = onLoadComplete

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .clear
        view.addGestureRecognizer(tapRecognizer)

        view.add(subview: label, withConstraints: { make in
            make.center.equalToSuperview()
        })
    }

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        onLoadComplete?(.failed)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .error(forLoadedViewController: loadedViewControllerType))
    }

    // MARK: interface actions
    @objc
    private func viewTapped() {
        onTap()
    }
}
