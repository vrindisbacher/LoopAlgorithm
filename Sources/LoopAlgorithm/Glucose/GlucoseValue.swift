//
//  GlucoseValue.swift
//
//  Created by Nathan Racklyeft on 3/2/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif

public protocol GlucoseValue: SampleValue {
}

public struct SimpleGlucoseValue: Equatable, GlucoseValue {
    public let startDate: Date
    public let endDate: Date
    public let quantity: LoopQuantity

    public init(startDate: Date, endDate: Date? = nil, quantity: LoopQuantity) {
        self.startDate = startDate
        self.endDate = endDate ?? startDate
        self.quantity = quantity
    }

    public init(_ glucoseValue: GlucoseValue) {
        self.startDate = glucoseValue.startDate
        self.endDate = glucoseValue.endDate
        self.quantity = glucoseValue.quantity
    }
}

public struct PredictedGlucoseValue: Equatable, GlucoseValue {
    public let startDate: Date
    public let quantity: LoopQuantity

    public init(startDate: Date, quantity: LoopQuantity) {
        self.startDate = startDate
        self.quantity = quantity
    }
}
