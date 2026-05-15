//
//  DoseRecommendationType.swift
//  LoopAlgorithm
//
//  Created by Pete Schwamb on 10/12/23.
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

import Foundation


public enum DoseRecommendationType: String, Codable {
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
