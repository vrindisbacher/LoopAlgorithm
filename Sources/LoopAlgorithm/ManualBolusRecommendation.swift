//
//  ManualBolusRecommendation.swift
//  LoopAlgorithm
//
//  Created by Pete Schwamb on 1/2/17.
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

import Foundation

public enum BolusRecommendationNotice: Equatable {
    case glucoseBelowSuspendThreshold(minGlucose: SimpleGlucoseValue)
    case currentGlucoseBelowTarget(glucose: SimpleGlucoseValue)
    case predictedGlucoseBelowTarget(minGlucose: SimpleGlucoseValue)
    case predictedGlucoseInRange
    case allGlucoseBelowTarget(minGlucose: SimpleGlucoseValue)
}

extension BolusRecommendationNotice {
    private struct GlucoseBelowSuspendThreshold {
        let minGlucose: SimpleGlucoseValue
    }

    private struct CurrentGlucoseBelowTarget {
        let glucose: SimpleGlucoseValue
    }

    private struct PredictedGlucoseBelowTarget {
        let minGlucose: SimpleGlucoseValue
    }

    private struct AllGlucoseBelowTarget {
        let minGlucose: SimpleGlucoseValue
    }

    private enum CodableKeys: String, CodingKey {
        case glucoseBelowSuspendThreshold
        case currentGlucoseBelowTarget
        case predictedGlucoseBelowTarget
        case predictedGlucoseInRange
        case allGlucoseBelowTarget
    }
}

public struct ManualBolusRecommendation {
    public var amount: Double
    public var notice: BolusRecommendationNotice?

    public init(amount: Double, notice: BolusRecommendationNotice? = nil) {
        self.amount = amount
        self.notice = notice
    }
}

extension ManualBolusRecommendation {}

extension ManualBolusRecommendation: Equatable {
    public static func == (lhs: ManualBolusRecommendation, rhs: ManualBolusRecommendation) -> Bool {
        return lhs.amount == rhs.amount
    }
}
