import SnapKit
import Then
import UIKit

public final class WhatToWearHeaderView: CodeBackedView {
    // MARK: State
    public enum State {
        case noButtons
        case rulesOnly(rulesButton: BorderedButton)
        case rulesAndLegend(rulesButton: BorderedButton, legendButton: BorderedButton)
    }

    // MARK: Config
    public enum Params {
        case noButtons
        case rulesOnly(onRulesButtonTap: () -> Void)
        case rulesAndLegend(onRulesButtonTap: () -> Void, onLegendButtonTap: () -> Void)

        // MARK: computed properties
        fileprivate var onRulesButtonTap: (() -> Void)? {
            switch self {
                case .noButtons:
                    return nil
                case .rulesOnly(onRulesButtonTap: let onRulesButtonTap):
                    return onRulesButtonTap
                case .rulesAndLegend(onRulesButtonTap: let onRulesButtonTap, _):
                    return onRulesButtonTap
            }
        }

        fileprivate var onLegendButtonTap: (() -> Void)? {
            switch self {
                case .noButtons:
                    return nil
                case .rulesOnly(onRulesButtonTap: _):
                    return nil
                case .rulesAndLegend(_, onLegendButtonTap: let onLegendButtonTap):
                    return onLegendButtonTap
            }
        }
    }

    // MARK: properties
    private let label = UILabel().then {
        $0.text = NSLocalizedString("Met Rules", comment: "")
        $0.font = .boldSystemFont(ofSize: 22)
        $0.textColor = .white
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    private let bottomSeparatorView = SeparatorView()
    private let params: Params
    private lazy var state = makeState(params: params)

    // MARK: init
    public init(config: Params) {
        self.params = config

        super.init(frame: UIScreen.main.bounds)

        setupViews()
    }

    // MARK: init helpers
    private func makeState(params: Params) -> State {
        switch params {
            case .noButtons:
                return .noButtons
            case .rulesOnly:
                let rulesButton = makeRulesButton()
                
                return .rulesOnly(rulesButton: rulesButton)
            case .rulesAndLegend:
                let rulesButton = makeRulesButton()
                
                let legendButton = BorderedButton().then {
                    $0.titleLabel?.font = .systemFont(ofSize: 13)
                    $0.setTitle(NSLocalizedString("Legend", comment: ""), for: .normal)
                    $0.addTarget(self, action: #selector(legendButtonTapped), for: .touchUpInside)
                }
                
                return .rulesAndLegend(rulesButton: rulesButton, legendButton: legendButton)
        }
    }

    // MARK: setup
    private func setupViews() {
        add(subview: label, withConstraints: { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
        })

        switch state {
            case .noButtons:
                break
            case .rulesOnly(rulesButton: let rulesButton):
                add(subview: rulesButton, withConstraints: makeRulesButtonConstraints(for: state, after: label))
            case .rulesAndLegend(rulesButton: let rulesButton, legendButton: let legendButton):
                add(subview: legendButton, withConstraints: { make in
                    make.leading.greaterThanOrEqualTo(label.snp.trailing).offset(4)
                    make.height.equalTo(30).priority(.almostRequired)
                    make.centerY.equalToSuperview()
                    make.top.lessThanOrEqualToSuperview().offset(10)
                    make.bottom.greaterThanOrEqualToSuperview().inset(10)
                    make.width.equalTo(70).priority(.almostRequired)
                })

                add(subview: rulesButton, withConstraints: makeRulesButtonConstraints(for: state, after: legendButton))
        }

        add(subview: bottomSeparatorView, withConstraints: { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }

    // MARK: Making constraints
    private func makeRulesButton() -> BorderedButton {
        return BorderedButton().then {
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            $0.setTitle(NSLocalizedString("Rules", comment: ""), for: .normal)
            $0.addTarget(self, action: #selector(rulesButtonTapped), for: .touchUpInside)
        }
    }
    
    private func makeRulesButtonConstraints(for state: State, after beforeView: UIView) -> ((ConstraintMaker) -> Void) {
        return { make in
            switch state {
                case .noButtons:
                    break
                case .rulesOnly:
                    make.leading.greaterThanOrEqualTo(beforeView.snp.trailing).offset(4)
                case .rulesAndLegend:
                    make.leading.equalTo(beforeView.snp.trailing).offset(8)
            }
            
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(30).priority(.almostRequired)
            make.centerY.equalToSuperview()
            make.top.lessThanOrEqualToSuperview().offset(10)
            make.bottom.greaterThanOrEqualToSuperview().inset(10)
            make.width.equalTo(60)
        }
    }
    
    // MARK: interface actions
    @objc
    private func legendButtonTapped() {
        params.onLegendButtonTap?()
    }

    @objc
    private func rulesButtonTapped() {
        params.onRulesButtonTap?()
    }
}
