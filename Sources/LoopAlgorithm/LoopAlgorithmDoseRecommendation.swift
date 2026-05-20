//
//  LoopAlgorithmDoseRecommendation.swift
//  LoopAlgorithm
//
//  Created by Pete Schwamb on 10/11/23.
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
    import Foundation
#else
    import FoundationShim
#endif

public struct LoopAlgorithmDoseRecommendation: Equatable {

    public var manual: ManualBolusRecommendation?
    public var automatic: AutomaticDoseRecommendation?

    public init(
        manual: ManualBolusRecommendation? = nil, automatic: AutomaticDoseRecommendation? = nil
    ) {
        self.manual = manual
        self.automatic = automatic
    }
}

extension LoopAlgorithmDoseRecommendation {}
