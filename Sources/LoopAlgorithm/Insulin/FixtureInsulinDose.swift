//
//  FixtureInsulinDose.swift
//
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
    import Foundation
#else
import FoundationShim
    import FoundationShim
#endif

public struct FixtureInsulinDose: InsulinDose, Equatable {

    public var deliveryType: InsulinDeliveryType

    public var startDate: Date

    public var endDate: Date

    public var volume: Double

    public var insulinType: FixtureInsulinType?

    public var insulinModel: ExponentialInsulinModel {
        insulinType?.insulinModel ?? ExponentialInsulinModelPreset.rapidActingAdult.model
    }

    public init(
        deliveryType: InsulinDeliveryType, startDate: Date, endDate: Date, volume: Double,
        insulinType: FixtureInsulinType? = nil
    ) {
        self.deliveryType = deliveryType
        self.startDate = startDate
        self.endDate = endDate
        self.volume = volume
        self.insulinType = insulinType
    }
}
