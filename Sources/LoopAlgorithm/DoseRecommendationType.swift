//
//  DoseRecommendationType.swift
//  LoopAlgorithm
//
//  Created by Pete Schwamb on 10/12/23.
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif


public enum DoseRecommendationType: String {
    case manualBolus
    case automaticBolus
    case tempBasal

    var automated: Bool {
        switch self {
        case .automaticBolus, .tempBasal:
            return true
        case .manualBolus:
            return false
        }
    }
}
