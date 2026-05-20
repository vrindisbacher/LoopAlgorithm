//
//  CarbEntry.swift
//
//  Created by Nathan Racklyeft on 1/3/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif


public protocol CarbEntry: SampleValue {
    var absorptionTime: TimeInterval? { get }
}

