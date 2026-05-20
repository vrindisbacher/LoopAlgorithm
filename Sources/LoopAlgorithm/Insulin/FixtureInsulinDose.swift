//
//  FixtureInsulinDose.swift
//
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

import Foundation

public struct FixtureInsulinDose: InsulinDose, Equatable {

    public var deliveryType: InsulinDeliveryType

    public var startDate: Date

    public var endDate: Date

    public var volume: Double

    public var insulinType: FixtureInsulinType?

    public var insulinModel: InsulinModel {
        insulinType?.insulinModel ?? ExponentialInsulinModelPreset.rapidActingAdult
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