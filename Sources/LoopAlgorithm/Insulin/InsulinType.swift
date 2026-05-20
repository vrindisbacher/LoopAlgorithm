//
//  InsulinType.swift
//  LoopAlgorithm
//
//  Created by Anna Quinlan on 12/8/20.
//  Copyright © 2020 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
    import Foundation
#else
import FoundationShim
    import FoundationShim
#endif

public enum FixtureInsulinType: String, CaseIterable {
    case novolog
    case humalog
    case apidra
    case fiasp
    case lyumjev
    case afrezza

    var insulinModel: ExponentialInsulinModel {
        switch self {
        case .fiasp:
            return ExponentialInsulinModelPreset.fiasp.model
        case .lyumjev:
            return ExponentialInsulinModelPreset.lyumjev.model
        case .afrezza:
            return ExponentialInsulinModelPreset.afrezza.model
        default:
            return ExponentialInsulinModelPreset.rapidActingAdult.model
        }
    }
}
