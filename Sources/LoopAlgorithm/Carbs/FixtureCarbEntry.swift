//
//  StoredCarbEntry.swift
//
//  Created by Nathan Racklyeft on 1/22/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif

public struct FixtureCarbEntry: CarbEntry {
    public var absorptionTime: TimeInterval?
    public var startDate: Date
    public var quantity: LoopQuantity
    public var foodType: String?

    public init(
        absorptionTime: TimeInterval? = nil,
        startDate: Date,
        quantity: LoopQuantity,
        foodType: String? = nil
    ) {
        self.absorptionTime = absorptionTime
        self.startDate = startDate
        self.quantity = quantity
        self.foodType = foodType
    }
}
