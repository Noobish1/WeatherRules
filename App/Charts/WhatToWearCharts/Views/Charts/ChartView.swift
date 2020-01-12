import CoreGraphics
import Foundation
import UIKit
import WhatToWearCommonCore
import WhatToWearCore

public final class ChartView<ChartPainter: ChartPainterProtocol>: UIView {
    // MARK: properties
    private let dataProvider: DataProvider<ChartPainter.DataSet>
    private var boundsObserver: NSKeyValueObservation?

    // MARK: init
    public init(
        dataSets: NonEmptyArray<ChartPainter.DataSet>,
        xAxis: XAxis,
        leftAxis: YAxis,
        rightAxis: YAxis,
        extraOffsets: UIEdgeInsets
    ) {
        self.dataProvider = DataProvider(
            dataSets: dataSets,
            leftAxis: leftAxis,
            rightAxis: rightAxis,
            xAxis: xAxis,
            viewPortHandler: ViewPortHandler(rect: .zero, extraOffsets: extraOffsets)
        )

        super.init(frame: .zero)

        self.backgroundColor = UIColor.clear

        addKVOObservers()
        calculateOffsets()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeKVOObservers()
    }

    // MARK: observers
    private func addKVOObservers() {
        boundsObserver = observe(\.bounds) { [weak self] _, _ in
            self?.onBoundsChanged()
        }
    }

    private func removeKVOObservers() {
        if #available(iOS 11, *) {
            boundsObserver?.invalidate()
            boundsObserver = nil
        } else {
            // On iOS 10 the observer has to be removed like this
            if let observer = boundsObserver {
                self.removeObserver(observer, forKeyPath: "bounds")
                
                boundsObserver?.invalidate()
                boundsObserver = nil
            }
        }
    }

    private func onBoundsChanged() {
        if bounds.size != dataProvider.viewPortHandler.chartSize {
            dataProvider.viewPortHandler.updateChartSize(bounds.size)

            calculateOffsets()
        }
    }

    // MARK: drawing
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        AxisPainter.renderAxes(context: context, dataProvider: dataProvider)
        ChartPainter.drawDataAndValues(context: context, dataProvider: dataProvider)
    }

    // MARK: notifying
    private func calculateOffsets() {
        dataProvider.calculateOffsets()

        setNeedsDisplay()
    }
}
