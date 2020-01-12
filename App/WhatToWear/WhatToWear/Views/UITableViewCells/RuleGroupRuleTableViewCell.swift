import UIKit

internal final class RuleGroupRuleTableViewCell: RuleTableViewCell {
    // MARK: properties
    private let leftView = UIView()
    private let priorityLabel = UILabel().then {
        $0.textColor = .white
    }
    private let conditionsContainerView = UIView().then {
        $0.backgroundColor = .clear
    }

    // MARK: reuse
    internal override func prepareForReuse() {
        super.prepareForReuse()

        conditionsContainerView.subviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: setup
    internal override func setupViews() {
        // We don't call super as we setup all the constraints ourselves

        contentView.add(
            subview: leftView,
            withConstraints: { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().inset(21).priority(.high)
            },
            subviews: {
                $0.add(subview: nameLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })

                $0.add(subview: conditionsContainerView, withConstraints: { make in
                    make.top.equalTo(nameLabel.snp.bottom).offset(10)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            })

        contentView.add(subview: priorityLabel, withConstraints: { make in
            make.leading.greaterThanOrEqualTo(leftView.snp.trailing)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        })

        add(subview: bottomSeparatorView, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: configuration
    private func configureConditionsLabels(conditions: [ConditionViewModel]) {
        var labels: [UILabel] = []

        for (index, condition) in conditions.enumerated() {
            let label = UILabel().then {
                $0.text = condition.title
                $0.textColor = .white
                $0.font = .systemFont(ofSize: 15)
            }

            conditionsContainerView.add(subview: label, withConstraints: { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()

                if condition == conditions.first {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(labels[index - 1].snp.bottom)
                }

                if condition == conditions.last {
                    make.bottom.equalToSuperview()
                }
            })

            labels.append(label)
        }
    }

    internal func configure(with viewModel: RuleViewModel, priority: Int) {
        super.configure(with: viewModel)

        priorityLabel.text = String(priority)

        configureConditionsLabels(conditions: viewModel.conditions)
    }
}
