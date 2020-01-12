import Foundation
import WhatToWearCommonCore
import WhatToWearCore

// MARK: ShortLongFiniteSetViewModelProtocol
internal protocol ShortLongFiniteSetViewModelProtocol: FiniteSetViewModelProtocol {
    var longTitle: String { get }
    
    init(model: UnderlyingModel)
    init(underlyingModel: UnderlyingModel, shortTitle: String, longTitle: String)
    
    static func shortTitle(for value: UnderlyingModel) -> String
    static func longTitle(for value: UnderlyingModel) -> String
}

// MARK: extensions
extension ShortLongFiniteSetViewModelProtocol {
    // MARK: static computed properties
    internal static var nonEmptySet: NonEmptyArray<Self> {
        return UnderlyingModel.nonEmptyCases.map(Self.init)
    }
    
    // MARK: init
    internal init(model: UnderlyingModel) {
        self.init(underlyingModel: model, shortTitle: Self.shortTitle(for: model), longTitle: Self.longTitle(for: model))
    }
}
