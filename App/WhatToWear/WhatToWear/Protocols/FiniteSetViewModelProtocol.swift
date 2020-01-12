import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

internal protocol FiniteSetViewModelProtocol: Equatable {
    associatedtype UnderlyingModel: FiniteSetValueProtocol
    
    static var nonEmptySet: NonEmptyArray<Self> { get }
    var shortTitle: String { get }
    var underlyingModel: UnderlyingModel { get }
}
