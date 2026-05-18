import Foundation
import LoopAlgorithm

private func parseDate(_ d: Double) -> Date {
    Date(timeIntervalSinceReferenceDate: d)
}

private func convertFixtureInsulinType(_ i: FBSFixtureInsulinType) -> FixtureInsulinType {
    return switch i {
    case .novolog: FixtureInsulinType.novolog
    case .humalog: FixtureInsulinType.humalog
    case .apidra: FixtureInsulinType.apidra
    case .fiasp: FixtureInsulinType.fiasp
    case .lyumjev: FixtureInsulinType.lyumjev
    case .afrezza: FixtureInsulinType.afrezza
    }
}

private
    func convertUnit(_ u: FBSLoopUnit) -> LoopUnit
{
    switch u {
    case .gram:
        return .gram
    case .gramsPerUnit:
        return .gramsPerUnit
    case .internationalUnit:
        return .internationalUnit
    case .internationalUnitsPerHour:
        return .internationalUnitsPerHour
    case .milligramsPerDeciliter:
        return .milligramsPerDeciliter
    case .milligramsPerDeciliterPerSecond:
        return .milligramsPerDeciliterPerSecond
    case .milligramsPerDeciliterPerMinute:
        return .milligramsPerDeciliterPerMinute
    case .milligramsPerDeciliterPerInternationalUnit:
        return .milligramsPerDeciliterPerInternationalUnit
    case .millimolesPerLiter:
        return .millimolesPerLiter
    case .millimolesPerLiterPerSecond:
        return .millimolesPerLiterPerSecond
    case .millimolesPerLiterPerMinute:
        return .millimolesPerLiterPerMinute
    case .millimolesPerLiterPerInternationalUnit:
        return .millimolesPerLiterPerInternationalUnit
    case .percent:
        return .percent
    case .hour:
        return .hour
    case .minute:
        return .minute
    case .second:
        return .second
    }
}

private func convertQuantity(_ q: FBSLoopQuantity?) -> LoopQuantity? {
    guard let q else { return nil }
    return LoopQuantity(unit: convertUnit(q.unit), doubleValue: q.value)
}

public func convertInput(_ fb: FBSLoopAlgorithmInputFixture) -> AlgorithmInputFixture {
    let glucoseHistory = (0..<fb.glucoseHistoryCount).map { i -> FixtureGlucoseSample in
        let g = fb.glucoseHistory(at: i)!
        var f: FixtureGlucoseSample
        if g.provenanceIdentifier == nil {
            f = FixtureGlucoseSample(
                startDate: parseDate(g.startDate),
                quantity: convertQuantity(g.quantity)!,
                isDisplayOnly: g.isDisplayOnly,
                wasUserEntered: g.wasUserEntered
            )
        } else {
            f = FixtureGlucoseSample(
                provenanceIdentifier: g.provenanceIdentifier ?? "",
                startDate: parseDate(g.startDate),
                quantity: convertQuantity(g.quantity)!,
                isDisplayOnly: g.isDisplayOnly,
                wasUserEntered: g.wasUserEntered
            )
        }
        f.condition =
            g.condition == .belowRange ? GlucoseCondition.belowRange : GlucoseCondition.aboveRange
        f.trendRate = convertQuantity(g.trendRate)
        return f
    }

    let doses = (0..<fb.dosesCount).map { i -> FixtureInsulinDose in
        let d = fb.doses(at: i)!
        return FixtureInsulinDose(
            deliveryType: d.deliveryType == .bolus ? .bolus : .basal,
            startDate: parseDate(d.startDate),
            endDate: parseDate(d.endDate),
            volume: d.volume,
            insulinType: convertFixtureInsulinType(d.insulinType)
        )
    }

    let carbEntries = (0..<fb.carbEntriesCount).map { i -> FixtureCarbEntry in
        let c = fb.carbEntries(at: i)!
        return FixtureCarbEntry(
            absorptionTime: c.absorptionTime,
            startDate: parseDate(c.startDate),
            quantity: convertQuantity(c.quantity)!,
            foodType: c.foodType
        )
    }

    let basal = (0..<fb.basalCount).map { i -> AbsoluteScheduleValue<Double> in
        let b = fb.basal(at: i)!
        return AbsoluteScheduleValue(
            startDate: parseDate(b.startDate),
            endDate: parseDate(b.endDate),
            value: b.value
        )
    }

    let sensitivity = (0..<fb.sensitivityCount).map { i -> AbsoluteScheduleValue<LoopQuantity> in
        let s = fb.sensitivity(at: i)!
        return AbsoluteScheduleValue(
            startDate: parseDate(s.startDate),
            endDate: parseDate(s.endDate),
            value: convertQuantity(s.value)!
        )
    }

    let carbRatio = (0..<fb.carbRatioCount).map { i -> AbsoluteScheduleValue<Double> in
        let c = fb.carbRatio(at: i)!
        return AbsoluteScheduleValue(
            startDate: parseDate(c.startDate),
            endDate: parseDate(c.endDate),
            value: c.value
        )
    }

    let target = (0..<fb.targetCount).map { i in
        let t = fb.target(at: i)!
        let range = t.value!
        return AbsoluteScheduleValue(
            startDate: parseDate(t.startDate),
            endDate: parseDate(t.endDate),
            value: convertQuantity(range.lowerBound)!...convertQuantity(
                range.upperBound)!
        )
    }

    let carbAbsorptionModel =
        switch fb.carbAbsorptionModel {
        case .linear: CarbAbsorptionModel.linear
        case .piecewiseLinear: CarbAbsorptionModel.piecewiseLinear
        }

    let recommendationInsulinType =
        convertFixtureInsulinType(fb.recommendationInsulinType)

    let doseRecommendationType =
        switch fb.recommendationType {
        case .manualBolus: DoseRecommendationType.manualBolus
        case .automaticBolus: DoseRecommendationType.automaticBolus
        case .tempBasal: DoseRecommendationType.tempBasal
        }

    return AlgorithmInputFixture(
        predictionStart: parseDate(fb.predictionStart),
        glucoseHistory: glucoseHistory,
        doses: doses,
        carbEntries: carbEntries,
        basal: basal,
        sensitivity: sensitivity,
        carbRatio: carbRatio,
        target: target,
        suspendThreshold: convertQuantity(fb.suspendThreshold),
        maxBolus: fb.maxBolus,
        maxActiveInsulinMultiplier: fb.maxActiveInsulinMultiplier,
        maxBasalRate: fb.maxBasalRate,
        useIntegralRetrospectiveCorrection: fb.useIntegralRetrospectiveCorrection,
        useMidAbsorptionISF: fb.useMidAbsorptionIsf,
        includePositiveVelocityAndRC: fb.includePositiveVelocityAndRc,
        carbAbsorptionModel: carbAbsorptionModel,
        recommendationInsulinType: recommendationInsulinType,
        recommendationType: doseRecommendationType,
        automaticBolusApplicationFactor: fb.automaticbolusapplicationfactor,
        gradualTransitionsThreshold: fb.gradualtransitionsthreshold
    )
}
