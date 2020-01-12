import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

internal final class SelectViewController<T: ShortLongFiniteSetViewModelProtocol>: CodeBackedViewController, UITableViewDelegate, UITableViewDataSource, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = SelectViewController<T>

        case tableView = "tableView"
    }

    // MARK: Selection
    internal enum Selection {
        case noSelection
        indirect case selection(T)

        internal init(object: T?) {
            switch object {
                case .none: self = .noSelection
                case .some(let value): self = .selection(value)
            }
        }
    }

    // MARK: properties
    private let context: UIViewController.Type
    private let onSelection: (T) -> Void
    private let selections: NonEmptyArray<T>
    private let reuseIdentifier = "SelectionCell"
    private var selected: Selection
    private let gradientView = AppBackgroundView()
    private let navBarSeparatorView = SeparatorView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.isAccessibilityElement = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(TextTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.tableView)
    }

    // MARK: init/deinit
    internal init(
        context: UIViewController.Type,
        title: String,
        initial: Selection = .noSelection,
        selections: NonEmptyArray<T>,
        onSelection: @escaping (T) -> Void
    ) {
        self.context = context
        self.selected = initial
        self.selections = selections
        self.onSelection = onSelection

        super.init()

        self.title = title
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: gradientView)

        view.add(topSeparatorView: navBarSeparatorView, beneath: self.topLayoutGuide.snp.bottom)

        view.add(subview: tableView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        preselectRowIfNeeded()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .select(forType: T.self, from: context))
    }

    // MARK: preselection
    private func preselectRowIfNeeded() {
        if case .selection(let selection) = selected {
            if let row = selections.firstIndex(of: selection) {
                tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .top)
            }
        }
    }

    // MARK: UITableViewDataSource
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TextTableViewCell = tableView.wtw_dequeueReusableCell(identifier: reuseIdentifier, indexPath: indexPath)
        cell.configure(withText: selections[indexPath.row].longTitle)

        return cell
    }

    // MARK: UITableViewDelegate
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selection = selections[indexPath.row]

        switch selected {
            case .selection(let selected) where selected == selection:
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            case .noSelection, .selection: break
        }
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection(selections[indexPath.row])
    }
}
