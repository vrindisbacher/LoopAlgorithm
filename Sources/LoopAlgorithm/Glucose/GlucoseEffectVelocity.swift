//
//  GlucoseEffectVelocity.swift
//
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif

/// The first-derivative of GlucoseEffect, blood glucose over time.
public struct GlucoseEffectVelocity: SampleValue {
    public let startDate: Date
    public let endDate: Date
    public let quantity: LoopQuantity

    public init(startDate: Date, endDate: Date, quantity: LoopQuantity) {
        self.startDate = startDate
        self.endDate = endDate
        self.quantity = quantity
    }
}

extension GlucoseEffectVelocity {
    public static let perSecondUnit = LoopUnit.milligramsPerDeciliterPerSecond

    /// The integration of the velocity span
    public var effect: GlucoseEffect {
        let duration = endDate.timeIntervalSince(startDate)
        let velocityPerSecond = quantity.doubleValue(for: GlucoseEffectVelocity.perSecondUnit)

        return GlucoseEffect(
            startDate: endDate,
            quantity: LoopQuantity(
                unit: .milligramsPerDeciliter,
                doubleValue: velocityPerSecond * duration
            )
        )
    }
}
