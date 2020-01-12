import UIKit

import WhatToWearModels

internal protocol RulesAddViewControllerStateProtocol {
    associatedtype Object
    
    static var `default`: Self { get }
    
    init(object: Object, system: MeasurementSystem)
}

internal protocol RulesAddViewControllerProtocol: UIViewController {
    associatedtype Object
    associatedtype State: RulesAddViewControllerStateProtocol
    
    init(onDone: @escaping (Object) -> Void)
    init(state: State, onDone: @escaping (Object) -> Void)
}
