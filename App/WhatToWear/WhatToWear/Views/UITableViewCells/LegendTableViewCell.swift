import SnapKit
import UIKit
import WhatToWearAssets
import WhatToWearCoreUI
import WhatToWearModels

internal class LegendTableViewCell: TextTableViewCell {
    // MARK: properties
    private let colorView = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.layer.borderWidth = 1
        $0.layer.backgroundColor = UIColor.clear.cgColor
    }
    private let customAccessoryView = UIImageView(image: R.image.disclosureIndicator()).then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    // MARK: setup
    internal override func setupViews() {
        // This has to be done in this order because we layout left to right
        
        contentView.add(subview: colorView, withConstraints: { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(4)
        })
        
        super.setupViews()
        
        contentView.add(subview: customAccessoryView, withConstraints: { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 9, height: 13))
        })
    }
    
    // MARK: constraints
    internal override func titleLabelConstraints(
        for make: ConstraintMaker, textInsets: UIEdgeInsets
    ) {
        make.top.equalToSuperview().offset(textInsets.top)
        make.leading.equalTo(colorView.snp.trailing).offset(10)
        make.bottom.equalToSuperview().inset(textInsets.bottom + 1)
    }
    
    // MARK: updating
    private func updateColorViewConstraints(for componentType: WeatherChartComponentType) {
        colorView.snp.updateConstraints { make in
            make.size.equalTo(componentType.iconSize)
        }
    }
    
    private func updateColorView(with componentType: WeatherChartComponentType) {
        colorView.layer.borderColor = componentType.borderColor.cgColor
        colorView.backgroundColor = componentType.backgroundColor
        colorView.textColor = componentType.textColor
        colorView.text = componentType.testString
    }
    
    private func updateContentViewBackgroundColor(pressed: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.contentView.backgroundColor = pressed ? Colors.selectedBackground : nil
        }
    }
    
    // MARK: selection/highlighting
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        // We don't call super because we don't want the default selection functionality
        // The default selection functionality changes our colorView when selected/highlighted
        updateContentViewBackgroundColor(pressed: selected, animated: animated)
    }
    
    internal override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // We don't call super because we don't want the default selection functionality
        // The default selection functionality changes our colorView when selected/highlighted
        updateContentViewBackgroundColor(pressed: highlighted, animated: animated)
    }
    
    // MARK: configuration
    internal func configure(with viewModel: BasicLegendComponentViewModel) {
        super.configure(withText: viewModel.title)
        
        updateColorView(with: viewModel.componentType)
        updateColorViewConstraints(for: viewModel.componentType)
    }
}
