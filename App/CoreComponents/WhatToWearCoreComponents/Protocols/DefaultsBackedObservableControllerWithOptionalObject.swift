import Foundation
import RxRelay
import RxSwift
import WhatToWearCore

// MARK: DefaultsBackedObservableControllerWithOptionalObject
public protocol DefaultsBackedObservableControllerWithOptionalObject: DefaultsBackedControllerWithOptionalObject, Singleton {
    var relay: BehaviorRelay<Object?> { get }
}

// MARK: extenions
extension DefaultsBackedObservableControllerWithOptionalObject {
    // MARK: saving
    @discardableResult
    public func save(_ object: Object?) -> Object? {
        if let object = object {
            Self.saveWithoutSideEffects(object, config: config)
        } else {
            removeObject()
        }

        relay.accept(object)

        return object
    }
    
    // MARK: removing
    public func removeObject() {
        Self.removeObjectWithoutSideEffects(config: config)
        
        relay.accept(nil)
    }
}
