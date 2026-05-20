//
//  DoseType.swift
//  LoopAlgorithm
//
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif


/// A general set of ways insulin can be delivered by a pump
public enum InsulinDeliveryType: String, CaseIterable, Equatable {
    case bolus
    case basal
}

extension InsulinDeliveryType {}
