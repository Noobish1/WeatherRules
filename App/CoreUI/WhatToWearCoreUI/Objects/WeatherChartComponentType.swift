import Foundation
import WhatToWearModels

public enum WeatherChartComponentType {
    case line(color: UIColor)
    case filledLine(color: UIColor, fillAlpha: CGFloat)
    case scatter(color: UIColor, testString: String)
    
    public var testString: String {
        switch self {
            case .line: return ""
            case .filledLine: return ""
            case .scatter(_, testString: let testString): return testString
        }
    }
    
    public var backgroundColor: UIColor {
        switch self {
            case .line(color: let color):
                return color
            case .filledLine(color: let color, fillAlpha: let fillAlpha):
                return color.withAlphaComponent(fillAlpha)
            case .scatter:
                return .clear
        }
    }
    
    public var borderColor: UIColor {
        switch self {
            case .line: return .clear
            case .filledLine(color: let color, _): return color
            case .scatter: return .clear
        }
    }
    
    public var textColor: UIColor {
        switch self {
            case .line: return .clear
            case .filledLine: return .clear
            case .scatter(color: let color, _): return color
        }
    }
    
    public var iconSize: CGSize {
        switch self {
            case .line: return CGSize(width: 20, height: 4)
            case .filledLine, .scatter: return CGSize(width: 20, height: 20)
        }
    }
}
