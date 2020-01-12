import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

extension FullnessState where FullView: RuleAdditionFullViewProtocol, EmptyView == RuleEmptyView {
    internal init(viewModels: [FullView.ViewModel], emptyConfig: RuleEmptyView.Config) {
        if let nonEmptyViewModels = NonEmptyArray(array: viewModels) {
            self = .full(FullView(viewModels: nonEmptyViewModels))
        } else {
            self = .empty(RuleEmptyView(config: emptyConfig))
        }
    }
}
