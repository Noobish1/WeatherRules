import UIKit

internal protocol AddConditionButtonContentViewProtocol: UIView {
    var centeredView: UIView { get }
    var numberLabel: UILabel { get }
    var titleLabel: UILabel { get }
    var valueLabel: UILabel { get }
    var tickLabel: UILabel { get }
    var layout: AddConditionViewController.Layout { get }
}

extension AddConditionButtonContentViewProtocol {
    internal func setupViews() {
        add(subview: numberLabel, withConstraints: { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(layout.outerXPadding)
        })
        
        add(subview: tickLabel, withConstraints: { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(layout.outerXPadding)
        })
        
        add(subview: centeredView, withConstraints: { make in
            make.top.equalToSuperview().offset(20).priority(.high)
            make.top.greaterThanOrEqualToSuperview().offset(4)
            make.leading.greaterThanOrEqualTo(numberLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(tickLabel.snp.leading).inset(10)
            make.center.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(20).priority(.high)
        })
        
        centeredView.add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        
        centeredView.add(subview: valueLabel, withConstraints: { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10).priority(.high)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
}
