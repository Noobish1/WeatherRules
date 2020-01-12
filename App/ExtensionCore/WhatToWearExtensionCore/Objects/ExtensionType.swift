import ErrorRecorder
import Foundation

public enum ExtensionType {
    public enum CalculatedHeight {
        case noneCalculated
        case value(CGFloat)

        fileprivate var value: CGFloat? {
            switch self {
                case .noneCalculated: return nil
                case .value(let value): return value
            }
        }
    }
    
    case forecast
    case rules
    case combined

    // MARK: computed properties
    public var analyticsScreen: AnalyticsScreen.TodayExtension {
        switch self {
            case .forecast: return .forecast
            case .rules: return .rules
            case .combined: return .combined
        }
    }
    
    public func expandedHeight(forWidth width: CGFloat, innerCalculatedHeight: CalculatedHeight) -> CGFloat {
        switch self {
            case .forecast:
                return ceil(
                    ExtensionConstants.forecastTopAndBottomPadding +
                    ExtensionConstants.forecastLocationLabelHeight +
                    (width * ExtensionConstants.chartAspectRatio) +
                    ExtensionConstants.forecastTopAndBottomPadding
                )
            case .rules:
                return innerCalculatedHeight.value ?? 200
            case .combined:
                let chartHeight = (width * CombinedExtensionConstants.combinedChartAspectRatio)
                let middleHeight = max((innerCalculatedHeight.value ?? 200), chartHeight)
                
                return ceil(
                        ExtensionConstants.forecastTopAndBottomPadding +
                        CombinedExtensionConstants.combinedDateLabelHeight +
                        CombinedExtensionConstants.combinedInterLabelPadding +
                        ExtensionConstants.forecastLocationLabelHeight +
                        middleHeight +
                        CombinedExtensionConstants.combinedChartButtonsInterPadding +
                        CombinedExtensionConstants.combinedButtonsContainerHeight +
                        ExtensionConstants.forecastTopAndBottomPadding
                )
        }
    }
}
