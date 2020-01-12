import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

internal protocol RuleAdditionFullViewProtocol: UIView {
    associatedtype ViewModel
    
    init(viewModels: NonEmptyArray<ViewModel>)
    
    func update(with viewModels: NonEmptyArray<ViewModel>)
}
