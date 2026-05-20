//
//  CarbValue.swift
//
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif

public struct CarbValue: SampleValue {
    public let startDate: Date
    public let endDate: Date
    public var value: Double

    public var quantity: LoopQuantity {
        return LoopQuantity(unit: .gram, doubleValue: value)
    }

    public init(startDate: Date, endDate: Date? = nil, value: Double) {
        self.startDate = startDate
        self.endDate = endDate ?? startDate
        self.value = value
    }
}

extension CarbValue: Equatable {}
