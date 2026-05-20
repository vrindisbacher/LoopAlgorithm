//
//  RetrospectiveCorrection.swift
//  Loop
//
//  Copyright © 2019 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif


/// Derives a continued glucose effect from recent prediction discrepancies
public protocol RetrospectiveCorrection {

    /// Overall retrospective correction effect
    var totalGlucoseCorrectionEffect: LoopQuantity? { get }

    /// Calculates overall correction effect based on timeline of discrepancies, and updates glucoseCorrectionEffect
    ///
    /// - Parameters:
    ///   - startingAt: Initial glucose value
    ///   - retrospectiveGlucoseDiscrepanciesSummed: Timeline of past discepancies
    ///   - recencyInterval: how recent discrepancy data must be, otherwise effect will be cleared
    ///   - retrospectiveCorrectionGroupingInterval: Duration of discrepancy measurements
    /// - Returns: Glucose correction effects
    func computeEffect(
        startingAt startingGlucose: GlucoseValue,
        retrospectiveGlucoseDiscrepanciesSummed: [GlucoseChange]?,
        recencyInterval: TimeInterval,
        retrospectiveCorrectionGroupingInterval: TimeInterval
    ) -> [GlucoseEffect]
}
