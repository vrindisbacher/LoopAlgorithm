//
//  AbsorbedCarbValue.swift
//  LoopAlgorithm
//
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

import Foundation

/// A quantity of carbs absorbed over a given date interval
public struct AbsorbedCarbValue: SampleValue {
    /// The quantity of carbs absorbed
    public let observed: LoopQuantity
    /// The quantity of carbs absorbed, clamped to the original prediction
    public let clamped: LoopQuantity
    /// The quantity of carbs entered as eaten
    public let total: LoopQuantity
    /// The quantity of carbs expected to still absorb
    public let remaining: LoopQuantity
    /// The dates over which absorption was observed
    public let observedDate: DateInterval

    /// The predicted time for the remaining carbs to absorb
    public let estimatedTimeRemaining: TimeInterval

    // Total predicted absorption time for this carb entry
    public var estimatedDate: DateInterval {
        return DateInterval(
            start: observedDate.start, duration: observedDate.duration + estimatedTimeRemaining)
    }

    /// The amount of time required to absorb observed carbs
    public let timeToAbsorbObservedCarbs: TimeInterval

    /// Whether absorption is still in-progress
    public var isActive: Bool {
        return estimatedTimeRemaining > 0
    }

    public var observedProgress: LoopQuantity {
        let gram = LoopUnit.gram
        let totalGrams = total.doubleValue(for: gram)
        let percent = LoopUnit.percent

        guard totalGrams > 0 else {
            return LoopQuantity(unit: percent, doubleValue: 0)
        }

        return LoopQuantity(
            unit: percent,
            doubleValue: observed.doubleValue(for: gram) / totalGrams
        )
    }

    // MARK: SampleValue

    public var quantity: LoopQuantity {
        return clamped
    }

    public var startDate: Date {
        return estimatedDate.start
    }
}
