import NotificationCenter

extension NCWidgetDisplayMode {
    internal var analyticsValue: String {
        switch self {
            case .compact: return "compact"
            case .expanded: return "expanded"
            @unknown default: return "@unknown NCWidgetDisplayMode"
        }
    }
}
