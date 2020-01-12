import Foundation
import WhatToWearCoreUI

internal final class WhatsNewPadContainerViewController: CodeBackedViewController {
    // MARK: properties
    private let onDismiss: () -> Void
    
    // MARK: init
    internal init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        
        super.init()
    }
    
    // MARK: UIViewController
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let vc = WhatsNewViewController(context: .launch(onDismiss: { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.dismiss(animated: true)
            
            strongSelf.onDismiss()
        }))
        vc.modalPresentationStyle = .formSheet
        
        present(vc, animated: false)
    }
}
