import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

// MARK: SimpleFiniteSetViewModelProtocol
internal protocol SimpleFiniteSetViewModelProtocol: FiniteSetViewModelProtocol {
    init(model: UnderlyingModel)
    init(underlyingModel: UnderlyingModel, shortTitle: String)
    
    static func shortTitle(for value: UnderlyingModel) -> String
}

// MARK: extensions
extension SimpleFiniteSetViewModelProtocol {
    // MARK: static computed properties
    internal static var nonEmptySet: NonEmptyArray<Self> {
        return UnderlyingModel.nonEmptyCases.map(Self.init)
    }
    
    // MARK: init
    internal init(model: UnderlyingModel) {
        self.init(underlyingModel: model, shortTitle: Self.shortTitle(for: model))
    }
}
