import Foundation

public enum WhatsNewState: Equatable {
    case showWhatsNew
    case hideWhatsNew(updateSettings: Bool)
}
