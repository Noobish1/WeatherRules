import Foundation
import SnapKit

public final class BottomAnchoredContainerViewController: CodeBackedViewController, ContainerViewControllerProtocol {
    // MARK: property
    public let containerView = UIView().then {
        if InterfaceIdiom.current == .pad {
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 13
        }
    }
    private let backgroundView = BasicBackgroundView()
    private let innerViewController: BottomAnchoredInnerViewControllerProtocol
    private let layout = BottomAnchoredModalLayout()
    
    // MARK: init
    public init(innerViewController: BottomAnchoredInnerViewControllerProtocol) {
        self.innerViewController = innerViewController
        
        super.init()
    }
    
    // MARK: constraints
    private func makeContainerViewConstraints() -> ((ConstraintMaker) -> Void) {
        return { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.layout.containerViewBottomInset)
        }
    }
    
    private func makeGradientViewConstraints() -> ((ConstraintMaker) -> Void) {
        return { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(self.layout.gradientViewBottomOffset)
        }
    }
    
    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .white
        
        view.add(
            subview: containerView,
            withConstraints: makeContainerViewConstraints(),
            subviews: { container in
                container.add(subview: backgroundView, withConstraints: makeGradientViewConstraints())
                
                setupInitialViewController(innerViewController, containerView: containerView)
            }
        )
    }
    
    private func setupPreferredContentSize() {
        guard InterfaceIdiom.current == .pad else {
            return
        }
        
        var calculatedSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        calculatedSize.width = innerViewController.preferredContentWidth
        
        self.preferredContentSize = calculatedSize
    }
    
    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupPreferredContentSize()
    }
}
