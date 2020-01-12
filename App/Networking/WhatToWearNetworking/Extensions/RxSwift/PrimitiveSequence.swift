import Foundation
import RxSwift

// MARK: PrimitiveSequence with SingleTrait
extension PrimitiveSequence where Trait == SingleTrait {
    public func minimumDuration(_ duration: TimeInterval) -> PrimitiveSequence<Trait, Element> {
        let durationObservable = PrimitiveSequence<Trait, Int>
            .timer(.milliseconds(Int(duration * 1000)), scheduler: MainScheduler.instance)

        return .zip(self, durationObservable, resultSelector: { element, _ in element })
    }
}

// MARK: PrimitiveSequence with MaybeTrait
extension PrimitiveSequence where Trait == MaybeTrait {
    public func minimumDuration(_ duration: TimeInterval) -> PrimitiveSequence<Trait, Element> {
        let durationObservable = PrimitiveSequence<Trait, Int>
            .timer(.milliseconds(Int(duration * 1000)), scheduler: MainScheduler.instance)

        return .zip(self, durationObservable, resultSelector: { element, _ in element })
    }
}
