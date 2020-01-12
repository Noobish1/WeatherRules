import UIKit
import WhatToWearModels

internal protocol TimeSelectionRequesterProtocol: UIViewController {
    var timeInputTransitioner: BottomAnchoredTransitioner { get }
}

extension TimeSelectionRequesterProtocol {
    internal func promptUserForTime(
        initialTime: MilitaryTime,
        onDone: @escaping (MilitaryTime) -> Void
    ) {
        let vc = TimeInputViewController(
            context: type(of: self),
            time: initialTime,
            onDone: { vc, time in
                onDone(time)

                vc.dismiss(animated: true)
            }
        )
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = timeInputTransitioner

        present(vc, animated: true)
    }
}
