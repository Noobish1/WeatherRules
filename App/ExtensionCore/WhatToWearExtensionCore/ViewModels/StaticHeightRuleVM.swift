import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI

internal struct StaticHeightRuleVM {
    // MARK: properties
    internal let innerViewModel: RuleSectionViewModel
    internal let cellHeight: CGFloat

    // MARK: init
    internal init(viewModel: RuleSectionViewModel, prototypeCell: RuleSectionTableViewCell, width: CGFloat) {
        prototypeCell.configure(with: viewModel)

        self.innerViewModel = viewModel
        self.cellHeight = prototypeCell.heightForConstrainedWidth(width)
    }
}
