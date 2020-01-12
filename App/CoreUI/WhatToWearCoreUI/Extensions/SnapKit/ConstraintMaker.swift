import SnapKit

extension ConstraintMaker {
    public enum Side {
        case leading
        case trailing
        
        public var backgroundOffset: CGFloat {
            switch self {
                case .leading: return -1
                case .trailing: return 1
            }
        }
    }
    
    public func mv_constraint(for side: Side) -> ConstraintMakerExtendable {
        switch side {
            case .leading: return self.leading
            case .trailing: return self.trailing
        }
    }
}
