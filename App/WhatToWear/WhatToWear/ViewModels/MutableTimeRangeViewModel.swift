import Foundation
import RxCocoa
import RxRelay
import RxSwift
import WhatToWearCore
import WhatToWearModels

internal final class MutableTimeRangeViewModel: TimeRangeViewModelProtocol {
    // MARK: properties
    private let fromRelay: BehaviorRelay<String>
    private let toRelay: BehaviorRelay<String>
    internal private(set) var timeRange: TimeRange
    private let timeZone: TimeZone
    
    internal var fromDriver: Driver<String> {
        return fromRelay.asDriver()
    }
    
    internal var toDriver: Driver<String> {
        return toRelay.asDriver()
    }
    
    // MARK: init
    internal init(timeRange: TimeRange, timeZone: TimeZone) {
        let fromTitle = type(of: self).fromTitle(for: timeRange, timeZone: timeZone)
        let toTitle = type(of: self).toTitle(for: timeRange, timeZone: timeZone)
        
        self.fromRelay = BehaviorRelay(value: fromTitle)
        self.toRelay = BehaviorRelay(value: toTitle)
        self.timeRange = timeRange
        self.timeZone = timeZone
    }
    
    // MARK: update
    internal func update(with timeRange: TimeRange) {
        self.timeRange = timeRange
        
        let fromTitle = type(of: self).fromTitle(for: timeRange, timeZone: timeZone)
        let toTitle = type(of: self).toTitle(for: timeRange, timeZone: timeZone)
        
        fromRelay.accept(fromTitle)
        toRelay.accept(toTitle)
    }
}
