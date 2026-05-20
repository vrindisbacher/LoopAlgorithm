//
//  FixtureGlucoseSample.swift
//  LoopAlgorithm
//
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif

public struct FixtureGlucoseSample: GlucoseSampleValue, Equatable {
    public static let defaultProvenanceIdentifier = "com.LoopKit.Loop"

    public let provenanceIdentifier: String
    public let startDate: Date
    public let quantity: LoopQuantity
    public let isDisplayOnly: Bool
    public let wasUserEntered: Bool
    public var condition: GlucoseCondition?
    public var trendRate: LoopQuantity?

    public init(
        provenanceIdentifier: String = Self.defaultProvenanceIdentifier,
        startDate: Date,
        quantity: LoopQuantity,
        isDisplayOnly: Bool = false,
        wasUserEntered: Bool = false
    ) {
        self.provenanceIdentifier = provenanceIdentifier
        self.startDate = startDate
        self.quantity = quantity
        self.isDisplayOnly = isDisplayOnly
        self.wasUserEntered = wasUserEntered
    }
}
