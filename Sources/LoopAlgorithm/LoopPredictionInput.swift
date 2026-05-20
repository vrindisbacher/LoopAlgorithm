//
//  AlgorithmInput.swift
//  Learn
//
//  Created by Pete Schwamb on 7/29/23.
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

import Foundation

public struct LoopPredictionInput<
    CarbType: CarbEntry, GlucoseType: GlucoseSampleValue, InsulinDoseType: InsulinDose
> {
    // Algorithm input time range: t-10h to t
    public var glucoseHistory: [GlucoseType]

    // Algorithm input time range: t-16h to t
    public var doses: [InsulinDoseType]

    // Algorithm input time range: t-10h to t
    public var carbEntries: [CarbType]

    // Expected time range coverage: t-16h to t
    public var basal: [AbsoluteScheduleValue<Double>]

    // Expected time range coverage: t-16h to t (eventually with mid-absorption isf changes, it will be t-10h to t)
    public var sensitivity: [AbsoluteScheduleValue<LoopQuantity>]

    // Expected time range coverage: t-10h to t+6h
    public var carbRatio: [AbsoluteScheduleValue<Double>]

    public var algorithmEffectsOptions: AlgorithmEffectsOptions

    public var useIntegralRetrospectiveCorrection: Bool = false

    public var includePositiveVelocityAndRC: Bool = true

    public var carbAbsorptionModel: CarbAbsorptionModel = .piecewiseLinear

    public var gradualTransitionsThreshold: Double? = 40.0

    public init(
        glucoseHistory: [GlucoseType],
        doses: [InsulinDoseType],
        carbEntries: [CarbType],
        basal: [AbsoluteScheduleValue<Double>],
        sensitivity: [AbsoluteScheduleValue<LoopQuantity>],
        carbRatio: [AbsoluteScheduleValue<Double>],
        algorithmEffectsOptions: AlgorithmEffectsOptions,
        useIntegralRetrospectiveCorrection: Bool,
        includePositiveVelocityAndRC: Bool,
        carbAbsorptionModel: CarbAbsorptionModel,
        gradualTransitionsThreshold: Double? = 40.0
    ) {
        self.glucoseHistory = glucoseHistory
        self.doses = doses
        self.carbEntries = carbEntries
        self.basal = basal
        self.sensitivity = sensitivity
        self.carbRatio = carbRatio
        self.algorithmEffectsOptions = algorithmEffectsOptions
        self.useIntegralRetrospectiveCorrection = useIntegralRetrospectiveCorrection
        self.includePositiveVelocityAndRC = includePositiveVelocityAndRC
        self.carbAbsorptionModel = carbAbsorptionModel
        self.gradualTransitionsThreshold = gradualTransitionsThreshold
    }
}
