import UIKit

public enum FullnessState<EmptyView: UIView, FullView: UIView>: ContainerViewStateProtocol {
    case empty(EmptyView)
    case full(FullView)

    // MARK: computed properties
    public var view: UIView {
        switch self {
            case .empty(let view): return view
            case .full(let view): return view
        }
    }
}
