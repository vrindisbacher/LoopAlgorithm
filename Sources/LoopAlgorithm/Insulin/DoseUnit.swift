//
//  DoseUnit.swift
//  LoopAlgorithm
//
//  Created by Nathan Racklyeft on 3/28/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif


public enum DoseUnit: String {
    case unitsPerHour = "U/hour"
    case units        = "U"
}

extension DoseUnit {}
