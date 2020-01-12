import WhatToWearCommonCore
import WhatToWearCommonModels

internal struct PrecipitationData {
    // MARK: ChartStyle
    internal enum ChartStyle {
        case bars
        case linear
    }
    
    // MARK: init
    internal let precipEntries: NonEmptyArray<CGPoint>
    internal let accumationEntries: NonEmptyArray<PrecipDataEntry>
    internal let rainEntries: NonEmptyArray<CGPoint>
    internal let sleetEntries: NonEmptyArray<CGPoint>
    internal let snowEntries: NonEmptyArray<CGPoint>
    internal let lineColorEntries: NonEmptyArray<UIColor>
    
    // MARK: init
    internal init(dataPoints: NonEmptyArray<HourlyDataPoint>, chartStyle: ChartStyle) {
        let nonEmptyEntries = dataPoints.map(PrecipDataEntry.init)

        self.precipEntries = nonEmptyEntries.map { $0.point }
        self.accumationEntries = nonEmptyEntries
        self.rainEntries = Self.entries(from: nonEmptyEntries, for: .rain, chartStyle: chartStyle)
        self.sleetEntries = Self.entries(from: nonEmptyEntries, for: .sleet, chartStyle: chartStyle)
        self.snowEntries = Self.entries(from: nonEmptyEntries, for: .snow, chartStyle: chartStyle)
        self.lineColorEntries = Self.colorEntires(from: nonEmptyEntries)
    }
    
    // MARK: static init helpers
    private static func colorEntires(from entries: NonEmptyArray<PrecipDataEntry>) -> NonEmptyArray<UIColor> {
        return entries.map { entry in
            guard let precipType = entry.precipType else {
                return .clear
            }
            
            switch precipType {
                case .rain: return Self.color(for: precipType).lighter(by: 20.percent)
                case .sleet: return Self.color(for: precipType).lighter(by: 10.percent)
                case .snow: return Self.color(for: precipType)
            }
        }
    }
    
    // MARK: retrieving the correct drawing points for the given entries
    private static func entries(
        from entries: NonEmptyArray<PrecipDataEntry>,
        for precipType: PrecipitationType,
        chartStyle: ChartStyle
    ) -> NonEmptyArray<CGPoint> {
        var endArray = pointsForEntry(
            at: 0,
            in: entries.toArray(),
            precipType: precipType,
            chartStyle: chartStyle
        )
        
        let remainingEntries = Array(entries.dropFirst())
        
        for index in remainingEntries.indices {
            let newPoints = pointsForEntry(
                at: index,
                in: remainingEntries,
                precipType: precipType,
                chartStyle: chartStyle
            )
            
            newPoints.forEach { point in
                endArray.append(point)
            }
        }
        
        return endArray
    }
    
    private static func pointsForEntry(
        at index: Int,
        in entries: [PrecipDataEntry],
        precipType: PrecipitationType,
        chartStyle: ChartStyle
    ) -> NonEmptyArray<CGPoint> {
        let entry = entries[index]
        
        if entry.precipType == precipType {
            return pointsForMatchingEntry(entry, at: index, in: entries, chartStyle: chartStyle)
        } else {
            return pointsForMismatchingEntry(entry, at: index, in: entries)
        }
    }
    
    private static func pointsForMismatchingEntry(
        _ entry: PrecipDataEntry, at index: Int, in entries: [PrecipDataEntry]
    ) -> NonEmptyArray<CGPoint> {
        var endArray = NonEmptyArray(elements: CGPoint(x: entry.point.x, y: 0))
        
        if let nextEntry = entries[safe: index + 1] {
            endArray.append(CGPoint(x: nextEntry.point.x, y: 0))
        }
        
        return endArray
    }
    
    private static func pointsForMatchingEntry(
        _ entry: PrecipDataEntry,
        at index: Int,
        in entries: [PrecipDataEntry],
        chartStyle: ChartStyle
    ) -> NonEmptyArray<CGPoint> {
        var endArray = NonEmptyArray(elements: entry.point)
        
        if let nextEntry = entries[safe: index + 1] {
            endArray.append(nextEntry.point.with { point in
                switch chartStyle {
                    case .bars: point.y = entry.point.y
                    case .linear: point.y = nextEntry.point.y
                }
            })
        } else {
            endArray.append(CGPoint(x: entry.point.x, y: 0))
        }
        
        return endArray
    }
    
    // MARK: colors
    internal static func color(for precipitationType: PrecipitationType) -> UIColor {
        switch precipitationType {
            case .rain: return UIColor(hex: 0x1695c4)
            case .sleet: return UIColor(hex: 0x1695c4).lighter(by: 20.percent)
            case .snow: return .white
        }
    }
    
    internal func color(for precipitationType: PrecipitationType) -> UIColor {
        return Self.color(for: precipitationType)
    }
    
    // MARK: entries
    internal func entries(for precipitationType: PrecipitationType) -> NonEmptyArray<CGPoint> {
        switch precipitationType {
            case .rain: return rainEntries
            case .sleet: return sleetEntries
            case .snow: return snowEntries
        }
    }
}
