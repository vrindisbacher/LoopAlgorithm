//
//  AlgorithmInputFixture.swift
//
//
//  Created by Pete Schwamb on 2/23/24.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif

public enum AlgorithmInputFixtureDecodingError: Error {
    case invalidDoseRecommendationType
    case invalidInsulinType
    case doseRateMissing
    case doseVolumeMissing
}

public struct AlgorithmInputFixture: AlgorithmInput {
    public var predictionStart: Date
    public var glucoseHistory: [FixtureGlucoseSample]
    public var doses: [FixtureInsulinDose]
    public var carbEntries: [FixtureCarbEntry]
    public var basal: [AbsoluteScheduleValue<Double>]
    public var sensitivity: [AbsoluteScheduleValue<LoopQuantity>]
    public var carbRatio: [AbsoluteScheduleValue<Double>]
    public var target: GlucoseRangeTimeline
    public var suspendThreshold: LoopQuantity?
    public var maxBolus: Double
    public var maxActiveInsulinMultiplier: Double?
    public var maxBasalRate: Double
    public var useIntegralRetrospectiveCorrection: Bool
    public var includePositiveVelocityAndRC: Bool
    public var useMidAbsorptionISF: Bool
    public var carbAbsorptionModel: CarbAbsorptionModel = .piecewiseLinear
    public var recommendationInsulinType: FixtureInsulinType = .novolog
    public var recommendationType: DoseRecommendationType = .automaticBolus
    public var automaticBolusApplicationFactor: Double?
    public var gradualTransitionsThreshold: Double?

    public var recommendationInsulinModel: InsulinModel {
        recommendationInsulinType.insulinModel
    }

    struct TargetEntry {
        var startDate: Date
        var endDate: Date
        var lowerBound: Double
        var upperBound: Double
    }

    struct Glucose {
        var value: Double
        var isCalibration: Bool
        var date: Date
    }

    public init(
        predictionStart: Date,
        glucoseHistory: [FixtureGlucoseSample],
        doses: [FixtureInsulinDose],
        carbEntries: [FixtureCarbEntry],
        basal: [AbsoluteScheduleValue<Double>],
        sensitivity: [AbsoluteScheduleValue<LoopQuantity>],
        carbRatio: [AbsoluteScheduleValue<Double>],
        target: GlucoseRangeTimeline,
        suspendThreshold: LoopQuantity?,
        maxBolus: Double,
        maxActiveInsulinMultiplier: Double? = nil,
        maxBasalRate: Double,
        useIntegralRetrospectiveCorrection: Bool = false,
        useMidAbsorptionISF: Bool = false,
        includePositiveVelocityAndRC: Bool = true,
        carbAbsorptionModel: CarbAbsorptionModel = .piecewiseLinear,
        recommendationInsulinType: FixtureInsulinType,
        recommendationType: DoseRecommendationType,
        automaticBolusApplicationFactor: Double? = nil,
        gradualTransitionsThreshold: Double? = 40.0
    ) {
        self.predictionStart = predictionStart
        self.glucoseHistory = glucoseHistory
        self.doses = doses
        self.carbEntries = carbEntries
        self.basal = basal
        self.sensitivity = sensitivity
        self.carbRatio = carbRatio
        self.target = target
        self.suspendThreshold = suspendThreshold
        self.maxBolus = maxBolus
        self.maxActiveInsulinMultiplier = maxActiveInsulinMultiplier
        self.maxBasalRate = maxBasalRate
        self.useIntegralRetrospectiveCorrection = useIntegralRetrospectiveCorrection
        self.includePositiveVelocityAndRC = includePositiveVelocityAndRC
        self.useMidAbsorptionISF = useMidAbsorptionISF
        self.carbAbsorptionModel = carbAbsorptionModel
        self.recommendationInsulinType = recommendationInsulinType
        self.recommendationType = recommendationType
        self.automaticBolusApplicationFactor = automaticBolusApplicationFactor
        self.gradualTransitionsThreshold = gradualTransitionsThreshold
    }
}
extension GlucoseSampleValue {
    var asFixtureGlucoseSample: FixtureGlucoseSample {
        return .init(startDate: startDate, quantity: quantity)
    }
}

extension InsulinDose {
    var asFixtureInsulinDose: FixtureInsulinDose {
        return .init(
            deliveryType: deliveryType, startDate: startDate, endDate: endDate, volume: volume)
    }
}

extension CarbEntry {
    var asFixtureCarbEntry: FixtureCarbEntry {
        return FixtureCarbEntry(
            absorptionTime: absorptionTime,
            startDate: startDate,
            quantity: quantity,
            foodType: nil
        )
    }
}
