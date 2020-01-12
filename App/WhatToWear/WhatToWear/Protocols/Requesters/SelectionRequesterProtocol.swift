import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

internal protocol SelectionRequesterProtocol: NavStackEmbedded {}

extension SelectionRequesterProtocol {
    private func promptUserForSelection<T: ShortLongFiniteSetViewModelProtocol>(
        title: String,
        initial: T?,
        selections: NonEmptyArray<T>,
        then: @escaping (T.UnderlyingModel) -> Void
    ) {
        let vc = SelectViewController<T>(
            context: type(of: self),
            title: title,
            initial: .init(object: initial),
            selections: selections,
            onSelection: { [navController] object in
                then(object.underlyingModel)

                navController.popViewController(animated: true)
            }
        )

        navController.pushViewController(vc, animated: true)
    }

    internal func promptUserForSelection<T: ShortLongFiniteSetViewModelProtocol>(
        title: String,
        initial: T?,
        then: @escaping (T.UnderlyingModel) -> Void
    ) {
        promptUserForSelection(
            title: title,
            initial: initial,
            selections: T.nonEmptySet,
            then: then
        )
    }
}
