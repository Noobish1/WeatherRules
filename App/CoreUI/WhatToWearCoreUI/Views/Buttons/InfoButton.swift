import UIKit
import WhatToWearAssets

public final class InfoButton: UIButton {
    public convenience init() {
        self.init(type: .system)

        self.setImage(R.image.infoButton(), for: .normal)
        self.tintColor = .white
    }
}
