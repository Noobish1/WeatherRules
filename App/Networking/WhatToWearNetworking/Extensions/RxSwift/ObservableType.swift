import Foundation
import RxSwift

// MARK: General ObservableType extensions
extension ObservableType {
    public func minimumDuration(_ duration: TimeInterval) -> Observable<Element> {
        let durationObservable = Observable<Int>.timer(.milliseconds(Int(duration * 1000)), scheduler: MainScheduler.instance)

        return Observable.zip(self, durationObservable, resultSelector: { element, _ in element })
    }
}
