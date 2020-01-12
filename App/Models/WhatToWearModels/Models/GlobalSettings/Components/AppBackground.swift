import Foundation
import WhatToWearCore

// MARK: AppBackground
public enum AppBackground {
    case gradient(hexColors: [Int], locations: [Double])
    case color(hex: Int)
}
