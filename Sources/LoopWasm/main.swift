import Foundation
import LoopAlgorithm

/* Wasm Input Types: Monomorphize everything */

public struct WasmGlucoseSample: Codable {
    public let value: Double
    public let timestamp: Int64
}

public struct WasmFixtureGlucoseSample: Codable {
    public static let defaultProvenanceIdentifier = "com.LoopKit.Loop"

    public let provenanceIdentifier: String
    public let startDate: Date
    public let quantity: LoopQuantity
    public let isDisplayOnly: Bool
    public let wasUserEntered: Bool
    public let condition: GlucoseCondition?
    public let trendRate: LoopQuantity?
}

public struct WasmFixtureInsulinDose: Codable {
    public let deliveryType: InsulinDeliveryType
    public let startDate: Date
    public let endDate: Date
    public let volume: Double
    public let insulinType: FixtureInsulinType?
}

public struct WasmFixtureCarbEntry: Codable {
    public let absorptionTime: TimeInterval?
    public let startDate: Date
    public let quantity: LoopQuantity
    public let foodType: String?
}

public struct WasmCarbEntry: Codable {
    public let grams: LoopQuantity
    public let timestamp: TimeInterval
}

public struct WasmScheduleValueDouble: Codable {
    public let startDate: Date
    public let endDate: Date
    public let value: Double
}

public struct WasmScheduleValueLoopQuantity: Codable {
    public let startDate: Date
    public let endDate: Date
    public let value: LoopQuantity
}

public struct WasmScheduleValueClosedRangeLoopQuantity: Codable {
    public let lowerBound: LoopQuantity
    public let upperBound: LoopQuantity
}

public struct WasmAbsoluteScheduleValueOfWasmScheduleValueClosedRangeLoopQuantity: Codable {
    public let startDate: Date
    public let endDate: Date
    public let value: WasmScheduleValueClosedRangeLoopQuantity
}

public typealias WasmGlucoseRangeTimeline =
    [WasmAbsoluteScheduleValueOfWasmScheduleValueClosedRangeLoopQuantity]

public struct WasmLoopAlgorithmInput: Codable {

    public let predictionStart: Date

    public let glucoseHistory: [WasmFixtureGlucoseSample]
    public let doses: [WasmFixtureInsulinDose]
    public let carbEntries: [WasmFixtureCarbEntry]

    public let basal: [WasmScheduleValueDouble]
    public let sensitivity: [WasmScheduleValueLoopQuantity]
    public let carbRatio: [WasmScheduleValueDouble]

    public let target: WasmGlucoseRangeTimeline

    public let suspendThreshold: LoopQuantity?

    public let maxBolus: Double
    public let maxActiveInsulinMultiplier: Double?

    public let maxBasalRate: Double

    public let useIntegralRetrospectiveCorrection: Bool
    public let includePositiveVelocityAndRC: Bool
    public let useMidAbsorptionISF: Bool

    public let carbAbsorptionModel: CarbAbsorptionModel
    public let recommendationInsulinModel: FixtureInsulinType
    public let recommendationType: DoseRecommendationType

    public let automaticBolusApplicationFactor: Double?
    public let gradualTransitionsThreshold: Double?
}

/* Wasm Output Types: Monomorphize everything */

public struct WasmDateInterval: Decodable {
    public let start: Date
    public let end: Date
    public let duration: TimeInterval
}

public struct WasmCarbValue: Decodable {
    public let startDate: Date
    public let endDate: Date
    public let value: Double
}

public struct WasmCarbStatusforCarbStatusType: Decodable {
    public let entry: WasmCarbEntry
    public let absorption: AbsorbedCarbValue?
    public let observedTimeline: [CarbValue]?
}

public struct WasmLoopAlgorithmEffectsforWasmCarbEntry: Decodable {
    public var insulin: [GlucoseEffect]
    public var carbs: [GlucoseEffect]
    public var carbStatus: [WasmCarbStatusforCarbStatusType]
    public var retrospectiveCorrection: [GlucoseEffect]
    public var momentum: [GlucoseEffect]
    public var insulinCounteraction: [GlucoseEffectVelocity]
    public var retrospectiveGlucoseDiscrepancies: [GlucoseChange]
    public var totalRetrospectiveCorrectionEffect: LoopQuantity?
}

public struct WasmPredictedGlucoseValue: Decodable {
    public let startDate: Date
    public let quantity: LoopQuantity
}

public enum WasmBasalRelativeDoseType: Decodable {
    case bolus
    case basal(scheduledRate: Double)
}

public enum WasmInsulinModelType: Decodable {
    case exponential
}

public struct WasmInsulineModelRepr: Decodable {
    public let effectDuration: TimeInterval
    public let delay: TimeInterval
    public let type: WasmInsulinModelType
}

public struct WasmBasalRelativeDose: Decodable {
    public let type: WasmBasalRelativeDoseType
    public let startDate: Date
    public let endDate: Date
    public let volume: Double
    public let insulinModel: WasmInsulineModelRepr
}

public struct WasmManualBolusRecommendation: Decodable {
    public let amount: Double
    public let notice: BolusRecommendationNotice
}

public enum WasmDirection: Decodable {
    case decrease
    case neutral
    case increase
}

public struct WasmError: Decodable {
    public let error_code: Int
}

public enum WasmResultWasmLoopAlgorithmDoseRecommendation: Decodable {
    case Ok(LoopAlgorithmDoseRecommendation)
    case Err(WasmError)
}

public struct WasmAlgorithmOutputforWasmCarbEntry: Decodable {
    public var recommendationResult: WasmResultWasmLoopAlgorithmDoseRecommendation
    public var predictedGlucose: [WasmPredictedGlucoseValue]
    public var effects: WasmLoopAlgorithmEffectsforWasmCarbEntry
    public var dosesRelativeToBasal: [WasmBasalRelativeDose]
    public var activeInsulin: Double?
    public var activeCarbs: Double?
}

@_expose(wasm, "run_algorithm")
public func run_algorithm(
    input: WasmLoopAlgorithmInput
) -> WasmAlgorithmOutputforWasmCarbEntry {

    let algoInput = AlgorithmInputFixture(

        predictionStart: input.predictionStart,

        glucoseHistory: input.glucoseHistory.map {
            var fix = FixtureGlucoseSample(
                provenanceIdentifier: $0.provenanceIdentifier,
                startDate: $0.startDate,
                quantity: $0.quantity,
                isDisplayOnly: $0.isDisplayOnly,
                wasUserEntered: $0.wasUserEntered,
            )
            fix.condition = $0.condition
            fix.trendRate = $0.trendRate
            return fix
        },

        doses: input.doses.map {
            FixtureInsulinDose(
                deliveryType: $0.deliveryType,
                startDate: $0.startDate,
                endDate: $0.endDate,
                volume: $0.volume,
                insulinType: $0.insulinType
            )
        },

        carbEntries: input.carbEntries.map {
            FixtureCarbEntry(
                absorptionTime: $0.absorptionTime,
                startDate: $0.startDate,
                quantity: $0.quantity,
                foodType: $0.foodType
            )
        },

        basal: input.basal.map {
            AbsoluteScheduleValue<Double>(
                startDate: $0.startDate,
                endDate: $0.endDate,
                value: $0.value
            )
        },

        sensitivity: input.sensitivity.map {
            AbsoluteScheduleValue<LoopQuantity>(
                startDate: $0.startDate,
                endDate: $0.endDate,
                value: $0.value,
            )
        },

        carbRatio: input.carbRatio.map {
            AbsoluteScheduleValue<Double>(
                startDate: $0.startDate,
                endDate: $0.endDate,
                value: $0.value
            )
        },

        target: input.target.map {
            AbsoluteScheduleValue<ClosedRange<LoopQuantity>>(
                startDate: $0.startDate,
                endDate: $0.endDate,
                value: ClosedRange(
                    uncheckedBounds: (lower: $0.value.lowerBound, upper: $0.value.upperBound))
            )
        },

        suspendThreshold: input.suspendThreshold,

        maxBolus: input.maxBolus,

        maxActiveInsulinMultiplier:
            input.maxActiveInsulinMultiplier,

        maxBasalRate: input.maxBasalRate,

        useIntegralRetrospectiveCorrection:
            input.useIntegralRetrospectiveCorrection,

        useMidAbsorptionISF:
            input.useMidAbsorptionISF,

        includePositiveVelocityAndRC:
            input.includePositiveVelocityAndRC,

        carbAbsorptionModel: input.carbAbsorptionModel,

        recommendationInsulinType: input.recommendationInsulinModel,

        recommendationType: input.recommendationType,

        automaticBolusApplicationFactor: input.automaticBolusApplicationFactor,

        gradualTransitionsThreshold: input.gradualTransitionsThreshold
    )

    let output: AlgorithmOutput<FixtureCarbEntry> = LoopAlgorithm.run(input: algoInput)

    return convertOutput(output)
}

private func convertOutput(
    _ output: AlgorithmOutput<FixtureCarbEntry>
) -> WasmAlgorithmOutputforWasmCarbEntry {

    let recommendationResult: WasmResultWasmLoopAlgorithmDoseRecommendation

    switch output.recommendationResult {

    case .success(let recommendation):
        recommendationResult = .Ok(
            LoopAlgorithmDoseRecommendation(
                manual: recommendation.manual,
                automatic: recommendation.automatic
            )
        )

    case .failure:
        recommendationResult = .Err(
            WasmError(error_code: 1)
        )
    }

    return WasmAlgorithmOutputforWasmCarbEntry(

        recommendationResult: recommendationResult,

        predictedGlucose: output.predictedGlucose.map {
            WasmPredictedGlucoseValue(
                startDate: $0.startDate,
                quantity: $0.quantity
            )
        },

        effects: WasmLoopAlgorithmEffectsforWasmCarbEntry(

            insulin: output.effects.insulin,

            carbs: output.effects.carbs,

            carbStatus: output.effects.carbStatus.map {
                WasmCarbStatusforCarbStatusType(
                    entry: WasmCarbEntry(
                        grams: $0.entry.quantity,
                        timestamp: $0.entry.startDate.timeIntervalSince1970
                    ),

                    absorption: $0.absorption,

                    observedTimeline: $0.observedTimeline,

                )
            },

            retrospectiveCorrection:
                output.effects.retrospectiveCorrection,

            momentum: output.effects.momentum,

            insulinCounteraction:
                output.effects.insulinCounteraction,

            retrospectiveGlucoseDiscrepancies:
                output.effects.retrospectiveGlucoseDiscrepancies,

            totalRetrospectiveCorrectionEffect:
                output.effects.totalRetrospectiveCorrectionEffect
        ),

        dosesRelativeToBasal:
            output.dosesRelativeToBasal.map {

                let type: WasmBasalRelativeDoseType

                switch $0.type {
                case .bolus:
                    type = .bolus

                case .basal(let scheduledRate):
                    type = .basal(
                        scheduledRate: scheduledRate
                    )
                }

                return WasmBasalRelativeDose(
                    type: type,
                    startDate: $0.startDate,
                    endDate: $0.endDate,
                    volume: $0.volume,

                    insulinModel: WasmInsulineModelRepr(
                        effectDuration:
                            $0.insulinModel.effectDuration,
                        delay:
                            $0.insulinModel.delay,
                        type: .exponential
                    )
                )
            },

        activeInsulin: output.activeInsulin,
        activeCarbs: output.activeCarbs
    )
}
