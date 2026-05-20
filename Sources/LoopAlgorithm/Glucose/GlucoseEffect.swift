//
//  GlucoseEffect.swift
//
//  Created by Nathan Racklyeft on 1/24/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import Foundation

public struct GlucoseEffect: GlucoseValue, Equatable {
    public let startDate: Date
    public let quantity: LoopQuantity

    public init(startDate: Date, quantity: LoopQuantity) {
        self.startDate = startDate
        self.quantity = quantity
    }
}

extension GlucoseEffect: Comparable {
    public static func < (lhs: GlucoseEffect, rhs: GlucoseEffect) -> Bool {
        return lhs.startDate < rhs.startDate
    }
}
