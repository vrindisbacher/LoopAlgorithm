//
//  ExponentialInsulinModelPreset.swift
//  LoopAlgorithm
//
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
    import Foundation
#else
import FoundationShim
    import FoundationShim
#endif

public enum ExponentialInsulinModelPreset: String {
    case rapidActingAdult
    case rapidActingChild
    case fiasp
    case lyumjev
    case afrezza
}

// MARK: - Model generation
extension ExponentialInsulinModelPreset {
    public var actionDuration: TimeInterval {
        switch self {
        case .rapidActingAdult:
            return .minutes(360)
        case .rapidActingChild:
            return .minutes(360)
        case .fiasp:
            return .minutes(360)
        case .lyumjev:
            return .minutes(360)
        case .afrezza:
            return .minutes(300)
        }
    }

    public var peakActivity: TimeInterval {
        switch self {
        case .rapidActingAdult:
            return .minutes(75)
        case .rapidActingChild:
            return .minutes(65)
        case .fiasp:
            return .minutes(55)
        case .lyumjev:
            return .minutes(55)
        case .afrezza:
            return .minutes(29)
        }
    }

    public var delay: TimeInterval {
        switch self {
        case .rapidActingAdult:
            return .minutes(10)
        case .rapidActingChild:
            return .minutes(10)
        case .fiasp:
            return .minutes(10)
        case .lyumjev:
            return .minutes(10)
        case .afrezza:
            return .minutes(10)
        }
    }

    public var model: ExponentialInsulinModel {
        return ExponentialInsulinModel(
            actionDuration: actionDuration, peakActivityTime: peakActivity, delay: delay)
    }
}

extension ExponentialInsulinModelPreset: InsulinModel {
    public var effectDuration: TimeInterval {
        return model.effectDuration
    }

    public func percentEffectRemaining(at time: TimeInterval) -> Double {
        return model.percentEffectRemaining(at: time)
    }
}
