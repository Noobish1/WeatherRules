import ErrorRecorder
import Then
import UIKit

public final class EndViewController: CodeBackedViewController, Accessible {
    // MARK: AccessibilityIdentifiers
    public enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        public typealias EnclosingType = EndViewController

        case mainView = "mainView"
        case titleLabel = "titleLabel"
        case subtitleLabel = "subtitleLabel"
    }

    // MARK: Context
    public enum Context {
        case mainApp
        case combinedTodayExtension
        
        // MARK: computed properties
        public var titleFont: UIFont {
            switch self {
                case .mainApp: return .boldSystemFont(ofSize: 40)
                case .combinedTodayExtension: return .boldSystemFont(ofSize: 30)
            }
        }
        
        public var subtitleFont: UIFont {
            switch self {
                case .mainApp: return .systemFont(ofSize: 20)
                case .combinedTodayExtension: return .systemFont(ofSize: 16)
            }
        }
        
        // MARK: analytics
        public func analyticsScreen(for side: Side) -> AnalyticsScreen {
            switch self {
                case .mainApp:
                    return .end(side: side.analyticsValue, target: .mainApp)
                case .combinedTodayExtension:
                    return .end(side: side.analyticsValue, target: .todayExtension(.combined))
            }
        }
    }
    
    // MARK: Side
    public enum Side {
        case past
        case future

        // MARK: computed properties
        public var analyticsValue: String {
            switch self {
                case .past: return "Past"
                case .future: return "Future"
            }
        }

        public var subtitle: String {
            switch self {
                case .future:
                    return NSLocalizedString("Unfortunately, the DarkSky API can only give forecasts up to a week into the future.", comment: "")
                case .past:
                    return NSLocalizedString("Unfortunately, the DarkSky API can only give forecasts up to two weeks into the past.", comment: "")
            }
        }
    }

    // MARK: properties
    private lazy var titleLabel = UILabel().then {
        $0.font = self.context.titleFont
        $0.text = NSLocalizedString("Sorry!", comment: "")
        $0.textAlignment = .center
        $0.textColor = .white
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.titleLabel)
    }
    private lazy var subtitleLabel = UILabel().then {
        $0.font = self.context.subtitleFont
        $0.text = self.side.subtitle
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .white
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.subtitleLabel)
    }
    private lazy var goBackButton = BorderedInsetButton(onTap: { [weak self] in
        self?.onButtonTap()
    }).then {
        $0.label.font = .systemFont(ofSize: 16)
        $0.label.text = NSLocalizedString("Go Back to Today", comment: "")
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    private let containerView = UIView()
    private let side: Side
    private let context: Context
    private let onButtonTap: () -> Void

    // MARK: init/deinit
    public init(side: Side, context: Context, onButtonTap: @escaping () -> Void) {
        self.side = side
        self.context = context
        self.onButtonTap = onButtonTap

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)
        view.backgroundColor = .clear

        view.add(
            subview: containerView,
            withConstraints: { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.centerY.equalToSuperview()
            },
            subviews: { container in
                container.add(subview: titleLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })

                container.add(subview: subtitleLabel, withConstraints: { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })

                container.add(subview: goBackButton, withConstraints: { make in
                    make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            }
        )
    }

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: context.analyticsScreen(for: side))
    }

    @objc
    private func buttonTapped() {
        onButtonTap()
    }
}
