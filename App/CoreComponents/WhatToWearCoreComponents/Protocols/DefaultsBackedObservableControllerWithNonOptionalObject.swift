import Foundation
import RxRelay
import RxSwift
import WhatToWearCore

// MARK: DefaultsBackedObservableControllerWithNonOptionalObject
public protocol DefaultsBackedObservableControllerWithNonOptionalObject: DefaultsBackedControllerWithNonOptionalObject, Singleton {
    var relay: BehaviorRelay<Object> { get }
}

// MARK: extenions
extension DefaultsBackedObservableControllerWithNonOptionalObject {
    // MARK: saving
    @discardableResult
    public func save(_ object: Object) -> Object {
        let object = Self.saveWithoutSideEffects(object, config: config)

        relay.accept(object)

        return object
    }
}
