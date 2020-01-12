import Foundation

// MARK: AxisFactoryProtocol
internal protocol AxisFactoryProtocol {}

// MARK: Extensions
extension AxisFactoryProtocol {
    // MARK: label font sizes
    internal static func labelFontSize(for context: WeatherChartView.Context) -> CGFloat {
        switch (InterfaceIdiom.current, context) {
            case (.pad, .legend): return 12
            case (.phone, _), (.pad, .todayExtension): return 10
            case (.pad, .mainApp): return 14
        }
    }
}
